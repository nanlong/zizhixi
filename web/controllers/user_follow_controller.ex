defmodule Zizhixi.UserFollowController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{User, UserFollow}

  import Guardian.Plug, only: [current_resource: 1]
  import Zizhixi.Ecto.Helpers, only: [inc: 3, dec: 3]
  import Zizhixi.Controller.Helpers, only: [redirect_to: 2]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]
    when action in [:create, :delete]

  # def index(conn, _params) do
  #   user_follows = Repo.all(UserFollow)
  #   render(conn, "index.html", user_follows: user_follows)
  # end

  def create(conn, %{"user_username" => username}) do
    current_user = current_resource(conn)
    follow_user = Repo.get_by!(User, %{username: username})

    if current_user == follow_user do
      raise Phoenix.NotAcceptableError
    end

    params = %{
      user_id: current_user.id,
      follow_id: follow_user.id
    }
    changeset = UserFollow.changeset(%UserFollow{}, params)

    conn = case Repo.insert(changeset) do
      {:ok, _user_follow} ->
        User |> inc(current_user, :following_count)
        User |> inc(follow_user, :followers_count)
        conn |> put_flash(:info, "关注成功.")
      {:error, _changeset} ->
        conn |> put_flash(:error, "关注失败.")
    end

    conn |> redirect_to(user_path(conn, :show, username))
  end

  def delete(conn, %{"user_username" => username}) do
    current_user = current_resource(conn)
    follow_user = Repo.get_by!(User, %{username: username})
    params = %{
      user_id: current_user.id,
      follow_id: follow_user.id
    }
    user_follow = Repo.get_by!(UserFollow, params)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user_follow)
    User |> dec(current_user, :following_count)
    User |> dec(follow_user, :followers_count)

    conn
    |> put_flash(:info, "取消关注成功.")
    |> redirect_to(user_path(conn, :show, username))
  end
end
