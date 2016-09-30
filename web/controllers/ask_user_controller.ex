defmodule Zizhixi.AskUserController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{User, AskUser, AskQuestion, AskAnswer, AskAnswerCollect}

  def show(conn, %{"username" => username, "tab" => "index"}) do
    user = Repo.get_by(User, %{username: username})

    questions = AskQuestion
    |> where(user_id: ^user.id)
    |> order_by([desc: :inserted_at])
    |> preload([:user])
    |> Repo.paginate(%{page: 1, page_size: 3})

    answers = AskAnswer
    |> where(user_id: ^user.id)
    |> order_by([desc: :inserted_at])
    |> preload([:user, :question])
    |> Repo.paginate(%{page: 1, page_size: 3})

    collects = AskAnswer
    |> join(:inner, [a], c in AskAnswerCollect, c.answer_id == a.id and c.user_id == ^user.id)
    |> order_by([_, c], [desc: c.inserted_at])
    |> preload([:user, :question])
    |> Repo.paginate(%{page: 1, page_size: 3})

    conn
    |> assign(:title, user.username <> " 的问答主页")
    |> assign(:current_tab, "index")
    |> assign(:user, user)
    |> assign(:ask_user, AskUser.get(user))
    |> assign(:questions, questions)
    |> assign(:answers, answers)
    |> assign(:collects, collects)
    |> render("show.html")
  end

  def show(conn, %{"username" => username, "tab" => "question"} = params) do
    user = Repo.get_by(User, %{username: username})

    pagination = AskQuestion
    |> where(user_id: ^user.id)
    |> order_by([desc: :inserted_at])
    |> preload([:user])
    |> Repo.paginate(params)

    conn
    |> assign(:title, user.username <> " 的提问")
    |> assign(:current_tab, "question")
    |> assign(:user, user)
    |> assign(:ask_user, AskUser.get(user))
    |> assign(:pagination, pagination)
    |> render("show-question.html")
  end

  def show(conn, %{"username" => username, "tab" => "answer"} = params) do
    user = Repo.get_by(User, %{username: username})

    pagination = AskAnswer
    |> where(user_id: ^user.id)
    |> order_by([desc: :inserted_at])
    |> preload([:user, :question])
    |> Repo.paginate(params)

    conn
    |> assign(:title, user.username <> " 的回答")
    |> assign(:current_tab, "answer")
    |> assign(:user, user)
    |> assign(:ask_user, AskUser.get(user))
    |> assign(:pagination, pagination)
    |> render("show-answer.html")
  end

  def show(conn, %{"username" => username, "tab" => "collect"} = params) do
    user = Repo.get_by(User, %{username: username})

    pagination = AskAnswer
    |> join(:inner, [a], c in AskAnswerCollect, c.answer_id == a.id and c.user_id == ^user.id)
    |> order_by([_, c], [desc: c.inserted_at])
    |> preload([:user, :question])
    |> Repo.paginate(params)

    conn
    |> assign(:title, user.username <> " 的收藏")
    |> assign(:current_tab, "collect")
    |> assign(:user, user)
    |> assign(:ask_user, AskUser.get(user))
    |> assign(:pagination, pagination)
    |> render("show-collect.html")
  end

  def show(conn, %{"username" => username}) do
    show(conn, %{"username" => username, "tab" => "index"})
  end
end
