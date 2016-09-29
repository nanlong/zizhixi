defmodule Zizhixi.QuestionView do
  use Zizhixi.Web, :view

  alias Zizhixi.{Repo, UserView, Question, QuestionWatch, AnswerThank, AnswerCollect}
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

  def thank?(conn, answer) do
    if authenticated?(conn) do
      current_user = current_resource(conn)
      params = %{answer_id: answer.id, user_id: current_user.id}
      not (AnswerThank |> Repo.get_by(params) |> is_nil)
    else
      false
    end
  end

  def collect?(conn, answer) do
    if authenticated?(conn) do
      current_user = current_resource(conn)
      params = %{answer_id: answer.id, user_id: current_user.id}
      not (AnswerCollect |> Repo.get_by(params) |> is_nil)
    else
      false
    end
  end
end
