defmodule Zizhixi.SessionController do
  use Zizhixi.Web, :controller

  alias Zizhixi.User

  import Zizhixi.Controller.Helpers, only: [redirect_to: 2]

  def new(conn, _params) do
    changeset = User.changeset(:signin, %User{})
    conn
    |> assign(:title, "用户登录")
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(:signin, %User{}, user_params)

    case changeset.valid? do
      true ->
        conn
        |> Guardian.Plug.sign_in(changeset.data)
        |> redirect_to(page_path(conn, :index))
      false ->
        changeset = %{changeset | action: :signin}
        conn
        |> assign(:title, "用户登录")
        |> render("new.html", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    Guardian.Plug.sign_out(conn)
    |> put_flash(:info, "已退出登录")
    |> redirect(to: page_path(conn, :index))
  end
end
