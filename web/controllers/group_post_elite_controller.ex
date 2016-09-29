defmodule Zizhixi.GroupPostEliteController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{GroupPost, UserNotification}

  import Guardian.Plug, only: [current_resource: 1]
  import Zizhixi.Ecto.Helpers, only: [update_field: 3]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]
    when action in [:create, :delete]

  def create(conn, %{"group_post_id" => group_post_id}) do
    current_user = current_resource(conn)

    group_post = GroupPost
    |> preload([:user, :group])
    |> Repo.get!(group_post_id)

    if group_post.group.user_id != current_user.id do
      raise Phoenix.ActionClauseError
    end

    group_post |> update_field(:is_elite, true)

    UserNotification.create(conn,
      user: group_post.user,
      who: current_user,
      where: group_post.group,
      action: "加精了",
      what: group_post
    )

    conn
    |> put_flash(:info, "加精成功.")
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

    group_post |> update_field(:is_elite, false)

    conn
    |> put_flash(:info, "取消加精成功.")
    |> redirect(to: group_post_path(conn, :show, group_post))
  end
end
