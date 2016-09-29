defmodule Zizhixi.QuestionWatchController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{User, Question, QuestionWatch}

  import Guardian.Plug, only: [current_resource: 1]
  import Zizhixi.Ecto.Helpers, only: [increment: 2, decrement: 2]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]

  def create(conn, %{"question_id" => question_id}) do
    current_user = current_resource(conn)
    question = Repo.get!(Question, question_id)
    params = %{
      question_id: question_id,
      user_id: current_user.id
    }
    changeset = QuestionWatch.changeset(%QuestionWatch{}, params)

    conn = case Repo.insert(changeset) do
      {:ok, _question_watch} ->
        question |> increment(:watch_count)
        conn |> put_flash(:info, "关注成功.")
      {:error, _changeset} ->
        conn |> put_flash(:error, "关注失败.")
    end

    conn |> redirect(to: question_path(conn, :show, question))
  end

  def show(conn, %{"question_id" => question_id} = params) do
    question = Repo.get!(Question, question_id)

    pagination = User
    |> join(:inner, [u], qw in QuestionWatch, qw.user_id == u.id and qw.question_id == ^question.id)
    |> order_by([_, qw], [desc: qw.inserted_at])
    |> Repo.paginate(params)

    conn
    |> assign(:title, to_string(question.watch_count) <> "人关注该问题")
    |> assign(:question, question)
    |> assign(:pagination, pagination)
    |> render("show.html")
  end

  def delete(conn, %{"question_id" => question_id}) do
    current_user = current_resource(conn)
    question = Repo.get!(Question, question_id)
    params = %{
      question_id: question_id,
      user_id: current_user.id
    }
    question_watch = Repo.get_by!(QuestionWatch, params)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(question_watch)
    question |> decrement(:watch_count)

    conn
    |> put_flash(:info, "取消关注成功.")
    |> redirect(to: question_path(conn, :show, question))
  end
end
