defmodule Zizhixi.AskQuestionController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{User, AskUser}
  alias Zizhixi.AskQuestion, as: Question
  alias Zizhixi.AskAnswer, as: Answer
  alias Zizhixi.AskQuestionPV, as: QuestionPV
  alias Zizhixi.AskQuestionWatch, as: QuestionWatch

  import Guardian.Plug, only: [current_resource: 1]
  import Zizhixi.Ecto.Helpers, only: [increment: 2]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]
    when action in [:new, :create, :edit, :update, :delete]

  def new(conn, _params) do
    changeset = Question.changeset(%Question{})

    conn
    |> assign(:title, "提问")
    |> assign(:changeset, changeset)
    |> render("new.html")
  end

  def create(conn, %{"ask_question" => question_params}) do
    current_user = current_resource(conn)
    params = question_params
    |> Map.put_new("user_id", current_user.id)
    changeset = Question.changeset(%Question{}, params)

    case Repo.insert(changeset) do
      {:ok, question} ->
        AskUser.get(current_user) |> increment(:question_count)

        conn
        |> put_flash(:info, "问题创建成功.")
        |> redirect(to: ask_question_path(conn, :show, question))
      {:error, changeset} ->
        conn
        |> assign(:title, "提问")
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end

  def show(conn, %{"id" => id, "sort" => sort}) do
    question = Question
    |> preload([:user])
    |> Repo.get!(id)

    answers_query = Answer
    |> where(question_id: ^id)
    |> preload([:user])

    answers = case sort == "created" do
      true -> answers_query |> order_by([desc: :inserted_at])
      false -> answers_query |> order_by([asc: :inserted_at])
    end
    |> Repo.all

    watches = User
    |> join(:inner, [u], qw in QuestionWatch, qw.user_id == u.id and qw.question_id == ^question.id)
    |> order_by([_, qw], [desc: qw.inserted_at])
    |> Repo.paginate(%{page: 1, page_size: 27})

    changeset = Answer.changeset(%Answer{})

    QuestionPV.create(conn, question, current_resource(conn))

    conn
    |> assign(:title, question.title)
    |> assign(:sort, sort)
    |> assign(:question, question)
    |> assign(:answers, answers)
    |> assign(:watches, watches)
    |> assign(:changeset, changeset)
    |> render("show.html")
  end

  def show(conn, %{"id" => id}) do
    show(conn, %{"id" => id, "sort" => "default"})
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

  def update(conn, %{"id" => id, "ask_question" => question_params}) do
    current_user = current_resource(conn)
    question = Repo.get_by!(Question, %{id: id, user_id: current_user.id})
    changeset = Question.changeset(question, question_params)

    case Repo.update(changeset) do
      {:ok, question} ->
        conn
        |> put_flash(:info, "问题编辑成功.")
        |> redirect(to: ask_question_path(conn, :show, question))
      {:error, changeset} ->
        conn
        |> assign(:title, "问题编辑")
        |> assign(:question, question)
        |> assign(:changeset, changeset)
        |> render("edit.html")
    end
  end
end
