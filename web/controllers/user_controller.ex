defmodule Zizhixi.UserController do
  use Zizhixi.Web, :controller

  alias Zizhixi.User

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = User.changeset(:signup, %User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(:signup, %User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def show(conn, %{"username" => username}) do
    user = Repo.get_by!(User, %{username: username})
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"view" => "account"}) do
    user = Guardian.Plug.current_resource(conn)
    changeset = User.changeset(:modify_password, user)
    render(conn, "edit-account.html", user: user, changeset: changeset)
  end

  def update(conn, %{"view" => "account", "user" => user_params}) do
    user = Guardian.Plug.current_resource(conn)
    changeset = User.changeset(:modify_password, user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "更新成功.")
        |> redirect(to: user_path(conn, :show, user.username))
      {:error, changeset} ->
        render(conn, "edit-modify_password.html", user: user, changeset: changeset)
    end
  end

  def update(conn, %{"username" => username, "user" => user_params}) do
    user = Repo.get_by!(User, %{username: username})
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end
