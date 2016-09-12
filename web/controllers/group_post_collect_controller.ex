defmodule Zizhixi.GroupPostCollectController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{GroupPost, GroupPostCollect}

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

    changeset = GroupPostCollect.changeset(%GroupPostCollect{}, params)

    conn = case Repo.insert(changeset) do
      {:ok, _group_post_collect} ->
        GroupPost |> inc(group_post, :collect_count)
        conn |> put_flash(:info, "收藏成功.")
      {:error, _changeset} ->
        conn |> put_flash(:error, "收藏失败.")
    end

    conn |> redirect(to: group_post_path(conn, :show, group_post.group_id, group_post))
  end

  def delete(conn, %{"group_post_id" => id}) do
    current_user = current_resource(conn)
    group_post = Repo.get!(GroupPost, id)

    params = %{
      post_id: group_post.id,
      user_id: current_user.id
    }

    group_post_collect = Repo.get_by!(GroupPostCollect, params)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(group_post_collect)
    GroupPost |> dec(group_post, :collect_count)

    conn
    |> put_flash(:info, "取消收藏成功.")
    |> redirect(to: group_post_path(conn, :show, group_post.group_id, group_post))
  end
end
