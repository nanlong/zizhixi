defmodule Zizhixi.QuestionAndAnswerController do
  use Zizhixi.Web, :controller

  alias Zizhixi.Question

  def index(conn, params) do
    pagination = Question
    |> order_by([desc: :inserted_at])
    |> preload([:user])
    |> Repo.paginate(params)

    conn
    |> assign(:title, "问答")
    |> assign(:pagination, pagination)
    |> render("index.html")
  end
end
