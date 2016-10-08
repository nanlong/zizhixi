defmodule Zizhixi.UserView do
  use Zizhixi.Web, :view

  def tabs(conn, user) do
    [
      {"profile", "个人信息", user_path(conn, :show, user.username)},
      {"followers", "关注者 (" <> to_string(user.followers_count) <> ")", user_path(conn, :show, user.username, tab: "followers")},
      {"following", "正在关注 (" <> to_string(user.following_count) <> ")", user_path(conn, :show, user.username, tab: "following")},
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
end
