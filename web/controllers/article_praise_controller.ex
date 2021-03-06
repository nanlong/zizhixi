defmodule Zizhixi.ArticlePraiseController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{Article, ArticleUser, ArticlePraise, UserNotification}

  import Guardian.Plug, only: [current_resource: 1]
  import Zizhixi.Ecto.Helpers, only: [increment: 2, decrement: 2]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]

  def create(conn, %{"article_id" => article_id}) do
    current_user = current_resource(conn)
    article = Article |> preload([:user]) |> Repo.get!(article_id)
    params = %{
      article_id: article_id,
      user_id: current_user.id
    }
    changeset = ArticlePraise.changeset(%ArticlePraise{}, params)

    conn = case Repo.insert(changeset) do
      {:ok, _article_praise} ->
        article |> increment(:praise_count)
        ArticleUser.get(current_user) |> increment(:praise_count)

        UserNotification.create(conn,
          user: article.user,
          who: current_user,
          where: nil,
          action: "赞了你的教程",
          what: article
        )

        conn |> put_flash(:info, "点赞成功.")
      {:error, _changeset} ->
        conn |> put_flash(:error, "点赞失败.")
    end

    conn |> redirect(to: article_path(conn, :show, article))
  end

  def delete(conn, %{"article_id" => article_id}) do
    current_user = current_resource(conn)
    article = Repo.get!(Article, article_id)
    params = %{
      article_id: article_id,
      user_id: current_user.id
    }
    article_praise = Repo.get_by!(ArticlePraise, params)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(article_praise)

    article |> decrement(:praise_count)
    ArticleUser.get(current_user) |> decrement(:praise_count)

    conn
    |> put_flash(:info, "取消点赞成功.")
    |> redirect(to: article_path(conn, :show, article))
  end
end
