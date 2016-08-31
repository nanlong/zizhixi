defmodule Zizhixi.UserView do
  use Zizhixi.Web, :view

  def render("detail.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      avatar: user.avatar,
    }
  end
end
