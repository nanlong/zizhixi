defmodule Zizhixi.QuestionAndAnswerController do
  use Zizhixi.Web, :controller

  # alias Zizhixi.QuestionAndAnswer
  #
  def index(conn, _params) do
    conn
    |> assign(:title, "问答")
    |> render("index.html")
  end
end
