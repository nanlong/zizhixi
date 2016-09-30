defmodule Zizhixi.AskUserController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{User, AskUser}

  def show(conn, %{"username" => username, "tab" => "index"}) do
    user = Repo.get_by(User, %{username: username})

    conn
    |> assign(:title, "问答主页")
    |> assign(:current_tab, "index")
    |> assign(:user, user)
    |> assign(:ask_user, AskUser.get(user))
    |> render("show.html")
  end

  def show(conn, %{"username" => username, "tab" => "question"}) do
    user = Repo.get_by(User, %{username: username})

    conn
    |> assign(:title, "问答主页")
    |> assign(:current_tab, "question")
    |> assign(:user, user)
    |> render("show-question.html")
  end

  def show(conn, %{"username" => username, "tab" => "answer"}) do
    user = Repo.get_by(User, %{username: username})

    conn
    |> assign(:title, "问答主页")
    |> assign(:current_tab, "answer")
    |> assign(:user, user)
    |> render("show-answer.html")
  end

  def show(conn, %{"username" => username, "tab" => "collect"}) do
    user = Repo.get_by(User, %{username: username})

    conn
    |> assign(:title, "问答主页")
    |> assign(:current_tab, "collect")
    |> assign(:user, user)
    |> render("show-collect.html")
  end

  def show(conn, %{"username" => username}) do
    show(conn, %{"username" => username, "tab" => "index"})
  end
end
