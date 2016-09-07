defmodule Zizhixi.UserView do
  use Zizhixi.Web, :view

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
