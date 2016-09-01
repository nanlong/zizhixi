defmodule Zizhixi.PostPraiseController do
  use Zizhixi.Web, :controller

  alias Zizhixi.PostPraise

  def index(conn, %{}) do
    post_praises = Repo.all(PostPraise)
    render(conn, "index.json", post_praises: post_praises)
  end

  def create(conn, %{"post_id" => post_id}) do
    params = %{
      post_id: post_id,
      user_id: "xxx"
    }
    changeset = PostPraise.changeset(%PostPraise{}, params)

    case Repo.insert(changeset) do
      {:ok, post_praise} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", post_praise_path(conn, :show, post_praise))
        |> render("show.json", post_praise: post_praise)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Zizhixi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post_praise = Repo.get!(PostPraise, id)
    render(conn, "show.json", post_praise: post_praise)
  end

  def update(conn, %{"id" => id, "post_praise" => post_praise_params}) do
    post_praise = Repo.get!(PostPraise, id)
    changeset = PostPraise.changeset(post_praise, post_praise_params)

    case Repo.update(changeset) do
      {:ok, post_praise} ->
        render(conn, "show.json", post_praise: post_praise)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Zizhixi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post_praise = Repo.get!(PostPraise, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post_praise)

    send_resp(conn, :no_content, "")
  end
end
