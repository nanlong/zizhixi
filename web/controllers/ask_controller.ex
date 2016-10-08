defmodule Zizhixi.AskController do
  use Zizhixi.Web, :controller

  alias Zizhixi.AskUser
  alias Zizhixi.AskQuestion, as: Question

  import Guardian.Plug, only: [current_resource: 1]

  def index(conn, %{"tab" => "index"} = params) do
    current_user = current_resource(conn)

    ask_user = case is_nil(current_user) do
      true -> nil
      false -> AskUser.get(current_user)
    end

    pagination = Question
    |> order_by([desc: :inserted_at])
    |> preload([:user])
    |> Repo.paginate(params)

    conn
    |> assign(:title, "问答")
    |> assign(:current_tab, "index")
    |> assign(:ask_user, ask_user)
    |> assign(:pagination, pagination)
    |> render("index.html")
  end

  def index(conn, %{"tab" => "answer"} = params) do
    current_user = current_resource(conn)

    ask_user = case is_nil(current_user) do
      true -> nil
      false -> AskUser.get(current_user)
    end

    pagination = Question
    |> where([q], is_nil(q.latest_answer_id))
    |> order_by([desc: :inserted_at])
    |> preload([:user])
    |> Repo.paginate(params)

    conn
    |> assign(:title, "问答")
    |> assign(:current_tab, "answer")
    |> assign(:ask_user, ask_user)
    |> assign(:pagination, pagination)
    |> render("index.html")
  end

  def index(conn, _params) do
    index(conn, %{"tab" => "index"})
  end
end
