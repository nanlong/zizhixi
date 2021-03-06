defmodule Zizhixi.ArticleCommentController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{Article, ArticleUser, ArticleComment, UserNotification}

  import Guardian.Plug, only: [current_resource: 1]
  import Zizhixi.Ecto.Helpers, only: [update_field: 3, increment: 2]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]

  def create(conn, %{"article_id" => article_id, "article_comment" => article_comment_params}) do
    current_user = current_resource(conn)
    article = Article |> preload([:user]) |> Repo.get!(article_id)

    params = article_comment_params
    |> Map.put_new("article_id", article_id)
    |> Map.put_new("user_id", current_user.id)
    |> Map.put_new("index", article.comment_count + 1)

    changeset = ArticleComment.changeset(%ArticleComment{}, params)

    conn = case Repo.insert(changeset) do
      {:ok, article_comment} ->
        article |> update_field(:latest_inserted_at, article_comment.inserted_at)
        article |> update_field(:latest_user_id, article_comment.user_id)
        article |> increment(:comment_count)

        ArticleUser.get(current_user) |> increment(:comment_count)

        UserNotification.create(conn,
          user: article.user,
          who: current_user,
          where: nil,
          action: "评论了你的教程",
          what: article_comment
        )

        conn |> put_flash(:info, "评论成功.")
      {:error, _changeset} ->
        conn |> put_flash(:error, "评论失败.")
    end

    conn |> redirect(to: article_path(conn, :show, article_id))
  end

  def edit(conn, %{"article_id" => article_id, "id" => id}) do
    current_user = current_resource(conn)
    article = Repo.get!(Article, article_id)
    article_comment = Repo.get_by!(ArticleComment, %{
      id: id,
      article_id: article_id,
      user_id: current_user.id
    })
    changeset = ArticleComment.changeset(article_comment)

    conn
    |> assign(:title, "编辑评论")
    |> assign(:article, article)
    |> assign(:article_comment, article_comment)
    |> assign(:changeset, changeset)
    |> render("edit.html")
  end

  def update(conn, %{"article_id" => article_id, "id" => id, "article_comment" => article_comment_params}) do
    current_user = current_resource(conn)
    article = Repo.get!(Article, article_id)
    article_comment = Repo.get_by!(ArticleComment, %{
      id: id,
      article_id: article_id,
      user_id: current_user.id
    })
    changeset = ArticleComment.changeset(article_comment, article_comment_params)

    case Repo.update(changeset) do
      {:ok, article_comment} ->
        conn
        |> put_flash(:info, "编辑评论成功.")
        |> redirect(to: article_path(conn, :show, article) <> "#reply" <> to_string(article_comment.index))
      {:error, changeset} ->
        conn
        |> assign(:title, "编辑评论")
        |> assign(:article, article)
        |> assign(:article_comment, article_comment)
        |> assign(:changeset, changeset)
        |> render("edit.html")
    end
  end

  def delete(conn, %{"article_id" => article_id, "id" => id}) do
    current_user = current_resource(conn)
    article = Repo.get!(Article, article_id)
    article_comment = Repo.get_by!(ArticleComment, %{
      id: id,
      article_id: article_id,
      user_id: current_user.id
    })

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    article_comment |> update_field(:is_deleted, true)

    conn
    |> put_flash(:info, "评论删除成功.")
    |> redirect(to: article_path(conn, :show, article))
  end
end
