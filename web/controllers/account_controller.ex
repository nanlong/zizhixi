defmodule Zizhixi.AccountController do
  use Zizhixi.Web, :controller

  alias Zizhixi.User

  def signup_page(conn, _params) do
    changeset = User.changeset(:signup, %User{})
    render conn, "signup.html", changeset: changeset
  end

  def signup(conn, %{"user" => user_params}) do
    changeset = User.changeset(:signup, %User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render conn, "signup.html", changeset: changeset
    end
  end

  def signin_page(conn, _params) do
    changeset = User.changeset(:signin, %User{})
    render conn, "signin.html", changeset: changeset
  end

  def signin(conn, %{"user" => user_params}) do
    changeset = User.changeset(:signin, %User{}, user_params)

    case changeset.valid? do
      true ->
        conn
        |> Guardian.Plug.sign_in(changeset.data)
        |> redirect(to: page_path(conn, :index))
      false ->
        changeset = %{changeset | action: :signin}
        render conn, "signin.html", changeset: changeset
    end
  end

end
