defmodule Zizhixi.PostCommentPraiseController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{PostComment, PostCommentPraise}

  import Zizhixi.Sqlalchemy, only: [inc: 3, dec: 3]

  def index(conn, %{"comment_id" => comment_id}) do
    post_comment = Repo.get!(PostComment, comment_id)

    post_comment_praises = PostCommentPraise
    |> where(post_comment_id: ^post_comment.id)
    |> Repo.all

    render(conn, "index.html", post_comment_praises: post_comment_praises)
  end

  def create(conn, %{"comment_id" => comment_id}) do
    current_user = Guardian.Plug.current_resource(conn)
    post_comment = Repo.get!(PostComment, comment_id)
    params = %{post_comment_id: post_comment.id, user_id: current_user.id}
    changeset = PostCommentPraise.changeset(%PostCommentPraise{}, params)

    conn = case Repo.insert(changeset) do
      {:ok, _post_comment_praise} ->
        PostComment |> inc(post_comment, :praise_count)
        conn |> put_flash(:info, "Post comment praise created successfully.")
      {:error, _changeset} ->
        conn |> put_flash(:info, "Post comment praise created faild.")
    end

    conn |> redirect(to: post_path(conn, :show, post_comment.post_id))
  end

  def delete(conn, %{"comment_id" => comment_id, "id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)
    post_comment = Repo.get!(PostComment, comment_id)
    params = %{id: id, post_comment_id: comment_id, user_id: current_user.id}
    post_comment_praise = Repo.get_by!(PostCommentPraise, params)

    Repo.delete!(post_comment_praise)
    PostComment |> dec(post_comment, :praise_count)

    conn
    |> put_flash(:info, "Post comment praise deleted successfully.")
    |> redirect(to: post_path(conn, :show, post_comment.post_id))
  end
end
