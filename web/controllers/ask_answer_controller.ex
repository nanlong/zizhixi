defmodule Zizhixi.AskAnswerController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{AskUser, AskQuestionWatch, UserNotification}
  alias Zizhixi.AskQuestion, as: Question
  alias Zizhixi.AskAnswer, as: Answer

  import Guardian.Plug, only: [current_resource: 1]
  import Zizhixi.Ecto.Helpers, only: [increment: 2, update_field: 3]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]

  def create(conn, %{"ask_question_id" => question_id, "ask_answer" => answer_params}) do
    current_user = current_resource(conn)
    question = Question |> preload([:user]) |> Repo.get!(question_id)
    params = answer_params
    |> Map.put_new("question_id", question_id)
    |> Map.put_new("user_id", current_user.id)
    changeset = Answer.changeset(%Answer{}, params)

    conn = case Repo.insert(changeset) do
      {:ok, answer} ->
        question
        |> increment(:answer_count)
        |> update_field(:latest_user_id, answer.user_id)
        |> update_field(:latest_answer_id, answer.id)
        |> update_field(:latest_inserted_at, answer.inserted_at)

        AskUser.get(current_user) |> increment(:answer_count)

        UserNotification.create(conn,
          user: question.user,
          who: current_user,
          where: nil,
          action: "回答了问题",
          what: answer
        )

        watch_users = AskQuestionWatch
        |> where([i], i.user_id != ^question.user_id and i.user_id != ^answer.user_id)
        |> where(question_id: ^answer.question_id)
        |> preload([:user])
        |> Repo.all

        Enum.map(watch_users, fn watch_user ->
          UserNotification.create(conn,
            user: watch_user.user,
            who: current_user,
            where: nil,
            action: "回答了问题",
            what: answer
          )
        end)

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
