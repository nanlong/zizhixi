defmodule Zizhixi.PostCommentController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{Post, PostComment}

  import Zizhixi.Sqlalchemy, only: [set: 4]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.GuardianErrorHandler]
    when action in [:create, :delete]

  plug Zizhixi.VerifyRequest, [model: PostComment, action: "is_owner"]
    when action in [:delete]

  def create(conn, %{"post_id" => post_id, "post_comment" => post_comment_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    post = Post |> Repo.get_by!(%{id: post_id, is_deleted: false})

    post_comment_params = post_comment_params
    |> Map.put_new("post_id", post.id)
    |> Map.put_new("user_id", current_user.id)

    changeset = PostComment.changeset(%PostComment{}, post_comment_params)

    case Repo.insert(changeset) do
      {:ok, _post_comment} ->
        conn
        |> put_flash(:info, "Post comment created successfully.")
        |> redirect(to: post_path(conn, :show, post_id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"post_id" => post_id, "id" => id}) do
    post = Post |> Repo.get_by!(%{id: post_id, is_deleted: false})
    post_comment = PostComment |> Repo.get_by!(%{id: id, post_id: post_id, is_deleted: false})
    render(conn, "show.html", post: post, post_comment: post_comment)
  end

  def delete(conn, %{"post_id" => post_id, "id" => id}) do
    post_comment = PostComment |> Repo.get_by!(%{id: id, post_id: post_id, is_deleted: false})

    PostComment |> set(post_comment, :is_deleted, true)

    conn
    |> put_flash(:info, "Post comment deleted successfully.")
    |> redirect(to: post_path(conn, :show, post_id))
  end
end
