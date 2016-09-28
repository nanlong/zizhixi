defmodule Zizhixi.QuestionController do
  use Zizhixi.Web, :controller

  alias Zizhixi.Question

  import Guardian.Plug, only: [current_resource: 1]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]
    when action in [:new, :create, :edit, :update, :delete]

  def new(conn, _params) do
    changeset = Question.changeset(%Question{})

    conn
    |> assign(:title, "提问")
    |> assign(:changeset, changeset)
    |> render("new.html")
  end

  def create(conn, %{"question" => question_params}) do
    current_user = current_resource(conn)
    params = question_params
    |> Map.put_new("user_id", current_user.id)
    changeset = Question.changeset(%Question{}, params)

    case Repo.insert(changeset) do
      {:ok, _question} ->
        conn
        |> put_flash(:info, "问题创建成功.")
        |> redirect(to: question_and_answer_path(conn, :index))
      {:error, changeset} ->
        conn
        |> assign(:title, "提问")
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end

  def show(conn, %{"id" => id}) do
    question = Question
    |> preload([:user])
    |> Repo.get!(id)

    conn
    |> assign(:title, question.title)
    |> assign(:question, question)
    |> render("show.html")
  end

  def edit(conn, %{"id" => id}) do
    current_user = current_resource(conn)
    question = Repo.get_by!(Question, %{id: id, user_id: current_user.id})
    changeset = Question.changeset(question)

    conn
    |> assign(:title, "问题编辑")
    |> assign(:question, question)
    |> assign(:changeset, changeset)
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "question" => question_params}) do
    current_user = current_resource(conn)
    question = Repo.get_by!(Question, %{id: id, user_id: current_user.id})
    changeset = Question.changeset(question, question_params)

    case Repo.update(changeset) do
      {:ok, question} ->
        conn
        |> put_flash(:info, "问题编辑成功.")
        |> redirect(to: question_path(conn, :show, question))
      {:error, changeset} ->
        conn
        |> assign(:title, "问题编辑")
        |> assign(:question, question)
        |> assign(:changeset, changeset)
        |> render("edit.html")
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = current_resource(conn)
    question = Repo.get_by!(Question, %{id: id, user_id: current_user.id})

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(question)

    conn
    |> put_flash(:info, "问题删除成功.")
    |> redirect(to: question_and_answer_path(conn, :index))
  end
end
