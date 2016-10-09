defmodule Zizhixi.AskAnswerView do
  use Zizhixi.Web, :view

  alias Zizhixi.{Repo, AskAnswer}
  import Guardian.Plug, only: [authenticated?: 1, current_resource: 1]
  import Ecto.Query

  def answer?(conn, question) do
    if authenticated?(conn) do
      current_user = current_resource(conn)

      answer_count = AskAnswer
      |> where(question_id: ^question.id)
      |> where(user_id: ^current_user.id)
      |> Repo.all
      |> Enum.count

      answer_count > 0
    else
      false
    end
  end

  def current_answer(conn, question) do
    current_user = current_resource(conn)

    AskAnswer
    |> where(question_id: ^question.id)
    |> where(user_id: ^current_user.id)
    |> order_by([asc: :inserted_at])
    |> first
    |> Repo.one
  end
end
