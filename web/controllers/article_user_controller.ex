defmodule Zizhixi.ArticleUserController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{User, ArticleUser}


  def show(conn, %{"username" => username}) do
    user = Repo.get_by!(User, %{username: username})
    article_user = ArticleUser.get(user)

    conn
    |> assign(:title, "天工个人主页")
    |> assign(:user, user)
    |> assign(:article_user, article_user)
    |> render("show.html")
  end
end
