defmodule Zizhixi.GroupPostPraiseController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{GroupUser, GroupPost, GroupPostPraise, UserNotification}

  import Guardian.Plug, only: [current_resource: 1]
  import Zizhixi.Ecto.Helpers, only: [inc: 3, dec: 3]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]
    when action in [:create, :delete]

  def create(conn, %{"group_post_id" => id}) do
    current_user = current_resource(conn)
    group_post = GroupPost |> preload([:user, :group]) |> Repo.get!(id)

    params = %{
      post_id: group_post.id,
      user_id: current_user.id
    }

    changeset = GroupPostPraise.changeset(%GroupPostPraise{}, params)

    conn = case Repo.insert(changeset) do
      {:ok, _group_post_praise} ->
        GroupPost |> inc(group_post, :praise_count)

        group_user = GroupUser.get(current_user.id)
        GroupUser |> inc(group_user, :praise_count)

        UserNotification.create(conn,
          user: group_post.user,
          who: current_user,
          where: group_post.group,
          action: "赞了",
          what: group_post
        )

        conn |> put_flash(:info, "点赞成功.")
      {:error, _changeset} ->
        conn |> put_flash(:error, "已点赞.")
    end

    conn |> redirect(to: group_post_path(conn, :show, group_post.id))
  end

  def delete(conn, %{"group_post_id" => id}) do
    current_user = current_resource(conn)
    group_post = Repo.get!(GroupPost, id)

    params = %{
      post_id: group_post.id,
      user_id: current_user.id
    }

    group_post_praise = Repo.get_by!(GroupPostPraise, params)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(group_post_praise)

    GroupPost |> dec(group_post, :praise_count)

    group_user = GroupUser.get(current_user.id)
    GroupUser |> dec(group_user, :praise_count)

    conn
    |> put_flash(:info, "取消点赞.")
    |> redirect(to: group_post_path(conn, :show, group_post.id))
  end
end
