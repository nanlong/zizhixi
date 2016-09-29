defmodule Zizhixi.AnswerController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{Answer, Question}

  import Guardian.Plug, only: [current_resource: 1]
  import Zizhixi.Ecto.Helpers, only: [inc: 3, dec: 3]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]

  def create(conn, %{"question_id" => question_id, "answer" => answer_params}) do
    current_user = current_resource(conn)
    question = Repo.get!(Question, question_id)
    params = answer_params
    |> Map.put_new("question_id", question_id)
    |> Map.put_new("user_id", current_user.id)
    changeset = Answer.changeset(%Answer{}, params)

    conn = case Repo.insert(changeset) do
      {:ok, _answer} ->
        Question |> inc(question, :answer_count)
        conn |> put_flash(:info, "创建回答成功.")
      {:error, _changeset} ->
        conn |> put_flash(:error, "创建回答失败.")
    end

    conn |> redirect(to: question_path(conn, :show, question))
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

  def update(conn, %{"id" => id, "answer" => answer_params}) do
    current_user = current_resource(conn)
    answer = Repo.get_by!(Answer, %{id: id, user_id: current_user.id})
    changeset = Answer.changeset(answer, answer_params)

    case Repo.update(changeset) do
      {:ok, answer} ->
        conn
        |> put_flash(:info, "修改回答成功.")
        |> redirect(to: question_path(conn, :show, answer.question_id))
      {:error, changeset} ->
        conn
        |> assign(:title, "修改回答")
        |> assign(:answer, answer)
        |> assign(:changeset, changeset)
        |> render("edit.html")
    end
  end
end