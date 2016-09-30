defmodule Zizhixi.UserFollowView do
  use Zizhixi.Web, :view

  alias Zizhixi.{Repo, User, UserFollow, ViewHelpers}

  def follow?(conn, %User{} = user) do
    if ViewHelpers.logged_in?(conn) do
      current_user = ViewHelpers.current_user(conn)
      params = %{user_id: current_user.id, follow_id: user.id}
      not (UserFollow |> Repo.get_by(params) |> is_nil)
    else
      false
    end
  end
end
