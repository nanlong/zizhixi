defmodule Zizhixi.QuestionView do
  use Zizhixi.Web, :view

  alias Zizhixi.{Repo, Question, QuestionWatch, UserView}
  import Guardian.Plug, only: [authenticated?: 1, current_resource: 1]

  def watch?(conn, question) do
    if authenticated?(conn) do
      current_user = current_resource(conn)
      params = %{question_id: question.id, user_id: current_user.id}
      not (QuestionWatch |> Repo.get_by(params) |> is_nil)
    else
      false
    end
  end
end
