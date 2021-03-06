defmodule Zizhixi.ArticleCommentPraiseController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{ArticleComment, ArticleCommentPraise, UserNotification}

  import Guardian.Plug, only: [current_resource: 1]
  import Zizhixi.Ecto.Helpers, only: [increment: 2, decrement: 2]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]

  def create(conn, %{"article_comment_id" => article_comment_id}) do
    current_user = current_resource(conn)
    article_comment = ArticleComment |> preload([:user]) |> Repo.get!(article_comment_id)
    params = %{
      comment_id: article_comment_id,
      user_id: current_user.id
    }
    changeset = ArticleCommentPraise.changeset(%ArticleCommentPraise{}, params)

    conn = case Repo.insert(changeset) do
      {:ok, _article_comment_praise} ->
        article_comment |> increment(:praise_count)

        UserNotification.create(conn,
          user: article_comment.user,
          who: current_user,
          where: nil,
          action: "赞了你的评论",
          what: article_comment
        )

        conn |> put_flash(:info, "点赞成功.")
      {:error, _changeset} ->
        conn |> put_flash(:error, "点赞失败.")
    end

    conn |> redirect(to: article_path(conn, :show, article_comment.article_id))
  end

  def delete(conn, %{"article_comment_id" => article_comment_id}) do
    current_user = current_resource(conn)
    article_comment = Repo.get!(ArticleComment, article_comment_id)
    params = %{
      comment_id: article_comment_id,
      user_id: current_user.id
    }
    article_comment_praise = Repo.get_by!(ArticleCommentPraise, params)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(article_comment_praise)
    article_comment |> decrement(:praise_count)

    conn
    |> put_flash(:info, "取消点赞成功.")
    |> redirect(to: article_path(conn, :show, article_comment.article_id))
  end
end
