defmodule Zizhixi.GroupPostWatchController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{GroupPost, GroupPostWatch}

  import Guardian.Plug, only: [current_resource: 1]
  import Zizhixi.Ecto.Helpers, only: [inc: 3, dec: 3]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]
    when action in [:create, :delete]

  def create(conn, %{"group_post_id" => id}) do
    current_user = current_resource(conn)
    group_post = Repo.get!(GroupPost, id)

    params = %{
      post_id: group_post.id,
      user_id: current_user.id
    }

    changeset = GroupPostWatch.changeset(%GroupPostWatch{}, params)

    conn = case Repo.insert(changeset) do
      {:ok, _group_post_watch} ->
        GroupPost |> inc(group_post, :watch_count)
        conn |> put_flash(:info, "关注成功.")
      {:error, _changeset} ->
        conn |> put_flash(:info, "关注失败.")
    end

    conn |> redirect(to: group_post_path(conn, :show, group_post))
  end

  def delete(conn, %{"group_post_id" => id}) do
    current_user = current_resource(conn)
    group_post = Repo.get!(GroupPost, id)

    params = %{
      post_id: group_post.id,
      user_id: current_user.id
    }

    group_post_watch = Repo.get_by!(GroupPostWatch, params)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(group_post_watch)
    GroupPost |> dec(group_post, :watch_count)

    conn
    |> put_flash(:info, "取消关注成功.")
    |> redirect(to: group_post_path(conn, :show, group_post))
  end
end
