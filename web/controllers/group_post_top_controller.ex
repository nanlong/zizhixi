defmodule Zizhixi.GroupPostTopController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{Group, GroupPost}

  import Guardian.Plug, only: [current_resource: 1]
  import Zizhixi.Ecto.Helpers, only: [set: 4]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]
    when action in [:create, :delete]

  def create(conn, %{"group_post_id" => group_post_id}) do
    current_user = current_resource(conn)

    group_post = GroupPost
    |> preload([:group])
    |> Repo.get!(group_post_id)

    if group_post.group.user_id != current_user.id do
      raise Phoenix.ActionClauseError
    end

    GroupPost |> set(group_post, :is_top, true)

    conn
    |> put_flash(:info, "置顶成功.")
    |> redirect(to: group_post_path(conn, :show, group_post))
  end

  def delete(conn, %{"group_post_id" => group_post_id}) do
    current_user = current_resource(conn)

    group_post = GroupPost
    |> preload([:group])
    |> Repo.get!(group_post_id)

    if group_post.group.user_id != current_user.id do
      raise Phoenix.ActionClauseError
    end

    GroupPost |> set(group_post, :is_top, false)

    conn
    |> put_flash(:info, "取消置顶成功.")
    |> redirect(to: group_post_path(conn, :show, group_post))
  end
end
