defmodule Zizhixi.UserView do
  use Zizhixi.Web, :view

  alias Zizhixi.{Repo, UserFollow}
  import Guardian.Plug, only: [authenticated?: 1, current_resource: 1]

  def tabs(conn, user) do
    [
      {"profile", "个人信息", user_path(conn, :show, user.username, tab: "profile")},
      {"followers", "关注者 <span class=\"tag is-info is-small\" style=\"margin-left: 5px;\">#{user.followers_count}</span>", user_path(conn, :show, user.username, tab: "followers")},
      {"following", "正在关注 <span class=\"tag is-info is-small\" style=\"margin-left: 5px;\">#{user.following_count}</span>", user_path(conn, :show, user.username, tab: "following")},
    ]
  end

  def subnav(conn) do
    [
      {"profile", "个人信息", user_path(conn, :edit, "profile")},
      {"password", "密码", user_path(conn, :edit, "password")},
    ]
  end

  def render("detail.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      avatar: user.avatar,
    }
  end

  def follow?(conn, user) do
    if authenticated?(conn) do
      current_user = current_resource(conn)
      params = %{user_id: current_user.id, follow_id: user.id}
      not (UserFollow |> Repo.get_by(params) |> is_nil)
    else
      false
    end
  end
end
