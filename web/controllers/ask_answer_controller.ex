defmodule Zizhixi.AskAnswerController do
  use Zizhixi.Web, :controller

  alias Zizhixi.AskUser
  alias Zizhixi.AskQuestion, as: Question
  alias Zizhixi.AskAnswer, as: Answer

  import Guardian.Plug, only: [current_resource: 1]
  import Zizhixi.Ecto.Helpers, only: [increment: 2]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]

  def create(conn, %{"ask_question_id" => question_id, "ask_answer" => answer_params}) do
    current_user = current_resource(conn)
    question = Repo.get!(Question, question_id)
    params = answer_params
    |> Map.put_new("question_id", question_id)
    |> Map.put_new("user_id", current_user.id)
    changeset = Answer.changeset(%Answer{}, params)

    conn = case Repo.insert(changeset) do
      {:ok, _answer} ->
        question |> increment(:answer_count)
        AskUser.get(current_user) |> increment(:answer_count)
        conn |> put_flash(:info, "创建回答成功.")
      {:error, _changeset} ->
        conn |> put_flash(:error, "创建回答失败.")
    end

    conn |> redirect(to: ask_question_path(conn, :show, question))
  end

  def edit(conn, %{"id" => id}) do
    current_user = current_resource(conn)
    answer = Repo.get_by!(Answer, %{id: id, user_id: current_user.id})
    changeset = Answer.changeset(answer)

    conn
    |> assign(:title, "修改回答")
    |> assign(:answer, answer)
    |> assign(:changeset, changeset)
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "ask_answer" => answer_params}) do
    current_user = current_resource(conn)
    answer = Repo.get_by!(Answer, %{id: id, user_id: current_user.id})
    changeset = Answer.changeset(answer, answer_params)

    case Repo.update(changeset) do
      {:ok, answer} ->
        conn
        |> put_flash(:info, "修改回答成功.")
        |> redirect(to: ask_question_path(conn, :show, answer.question_id))
      {:error, changeset} ->
        conn
        |> assign(:title, "修改回答")
        |> assign(:answer, answer)
        |> assign(:changeset, changeset)
        |> render("edit.html")
    end
  end
end
