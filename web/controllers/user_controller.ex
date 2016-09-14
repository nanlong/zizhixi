defmodule Zizhixi.UserController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{User, UserFollow}

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

  def show(conn, %{"username" => username, "tab" => "profile"}) do
    user = Repo.get_by!(User, %{username: username})

    upto = Timex.today
    since = Timex.shift(upto, years: -1, days: -1)

    conn
    |> assign(:title, "#{user.username}的个人信息")
    |> assign(:current_tab, "profile")
    |> assign(:since, since)
    |> assign(:upto, upto)
    |> render("show-profile.html", user: user)
  end

  def show(conn, %{"username" => username, "tab" => "followers"} = params) do
    user = Repo.get_by!(User, %{username: username})

    pagination = UserFollow
    |> where(follow_id: ^user.id)
    |> preload([:user])
    |> Repo.paginate(params)

    conn
    |> assign(:title, "#{user.username}的关注者")
    |> assign(:current_tab, "followers")
    |> render("show-followers.html", user: user, pagination: pagination)
  end

  def show(conn, %{"username" => username, "tab" => "following"} = params) do
    user = Repo.get_by!(User, %{username: username})

    pagination = UserFollow
    |> where(user_id: ^user.id)
    |> preload([:follow])
    |> Repo.paginate(params)

    conn
    |> assign(:title, "#{user.username}的正在关注")
    |> assign(:current_tab, "following")
    |> render("show-following.html", user: user, pagination: pagination)
  end

  def show(conn, %{"username" => username}) do
    show(conn, %{"username" => username, "tab" => "profile"})
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
      {:ok, _user} ->
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
      {:ok, _user} ->
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
