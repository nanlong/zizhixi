defmodule Zizhixi.AskAnswerThankController do
  use Zizhixi.Web, :controller

  alias Zizhixi.AskAnswer, as: Answer
  alias Zizhixi.AskAnswerThank, as: AnswerThank

  import Guardian.Plug, only: [current_resource: 1]
  import Zizhixi.Ecto.Helpers, only: [increment: 2, decrement: 2]
  import Zizhixi.Controller.Helpers, only: [redirect_to: 2]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]

  def create(conn, %{"ask_answer_id" => answer_id}) do
    current_user = current_resource(conn)
    answer = Repo.get!(Answer, answer_id)
    params = %{
      answer_id: answer_id,
      user_id: current_user.id
    }
    changeset = AnswerThank.changeset(%AnswerThank{}, params)

    case Repo.insert(changeset) do
      {:ok, _answer_thank} ->
        answer |> increment(:thank_count)
        conn
      {:error, _changeset} ->
        conn |> put_flash(:error, "感谢失败.")
    end
    |> redirect_to(ask_question_path(conn, :show, answer.question_id))
  end

  def delete(conn, %{"ask_answer_id" => answer_id}) do
    current_user = current_resource(conn)
    answer = Repo.get!(Answer, answer_id)
    params = %{
      answer_id: answer_id,
      user_id: current_user.id
    }
    answer_thank = Repo.get_by!(AnswerThank, params)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(answer_thank)

    answer |> decrement(:thank_count)

    conn |> redirect_to(ask_question_path(conn, :show, answer.question_id))
  end
end
