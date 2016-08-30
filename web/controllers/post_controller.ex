defmodule Zizhixi.PostController do
  use Zizhixi.Web, :controller

  alias Zizhixi.Post

  def index(conn, _params) do
    posts = Post |> where(is_deleted: false) |> Repo.all
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Post.changeset(:create, %Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    changeset = Post.changeset(:create, %Post{}, post_params |> Map.put_new("user_id", current_user.id))

    case Repo.insert(changeset) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: post_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Post |> where(is_deleted: false) |> Repo.get!(id)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => id}) do
    post = Post |> where(is_deleted: false) |> Repo.get!(id)
    changeset = Post.changeset(:update, post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Post |> where(is_deleted: false) |> Repo.get!(id)
    changeset = Post.changeset(:update, post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :show, post))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Post |> where(is_deleted: false) |> Repo.get!(id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    # Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end
end
