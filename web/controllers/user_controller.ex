defmodule Zizhixi.UserController do
  use Zizhixi.Web, :controller

  alias Zizhixi.User

  import Zizhixi.Controller.Helpers, only: [redirect_to: 2]

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = User.changeset(:signup, %User{})
    conn
    |> assign(:title, "用户注册")
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(:signup, %User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect_to(page_path(conn, :index))
      {:error, changeset} ->
        conn
        |> assign(:title, "用户注册")
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"username" => username}) do
    user = Repo.get_by!(User, %{username: username})
    render(conn, "show.html", user: user)
  end

  @doc """
  修改用户信息
  """
  def edit(conn, %{"view" => "profile"}) do
    user = Guardian.Plug.current_resource(conn)
    changeset = User.changeset(:settings_profile, user)

    conn
    |> assign(:title, "个人信息")
    |> assign(:view, "profile")
    |> render("edit-profile.html", user: user, changeset: changeset)
  end

  @doc """
  修改密码
  """
  def edit(conn, %{"view" => "password"}) do
    user = Guardian.Plug.current_resource(conn)
    changeset = User.changeset(:settings_profile, user)

    conn
    |> assign(:title, "修改密码")
    |> assign(:view, "password")
    |> render("edit-password.html", user: user, changeset: changeset)
  end

  def update(conn, %{"view" => "profile", "user" => user_params}) do
    user = Guardian.Plug.current_resource(conn)
    changeset = User.changeset(:settings_profile, user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "个人信息修改成功")
        |> redirect(to: user_path(conn, :edit, "profile"))
      {:error, changeset} ->
        conn
        |> assign(:title, "个人信息")
        |> assign(:view, "profile")
        |> render("edit-profile.html", user: user, changeset: changeset)
    end
  end

  def update(conn, %{"view" => "password", "user" => user_params}) do
    user = Guardian.Plug.current_resource(conn)
    changeset = User.changeset(:settings_password, user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "密码更新成功")
        |> redirect(to: user_path(conn, :edit, "password"))
      {:error, changeset} ->
        conn
        |> assign(:title, "修改密码")
        |> assign(:view, "password")
        |> render("edit-password.html", user: user, changeset: changeset)
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
