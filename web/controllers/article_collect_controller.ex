defmodule Zizhixi.ArticleCollectController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{Article, ArticleUser, ArticleCollect}

  import Guardian.Plug, only: [current_resource: 1]
  import Zizhixi.Ecto.Helpers, only: [inc: 3, dec: 3]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]

  def create(conn, %{"article_id" => article_id}) do
    current_user = current_resource(conn)
    article = Repo.get!(Article, article_id)
    params = %{
      article_id: article_id,
      user_id: current_user.id
    }
    changeset = ArticleCollect.changeset(%ArticleCollect{}, params)

    conn = case Repo.insert(changeset) do
      {:ok, _article_praise} ->
        Article |> inc(article, :collect_count)

        article_user = ArticleUser.get(current_user)
        ArticleUser |> inc(article_user, :collect_count)

        conn |> put_flash(:info, "收藏成功.")
      {:error, _changeset} ->
        conn |> put_flash(:error, "收藏失败.")
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
    article_collect = Repo.get_by!(ArticleCollect, params)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(article_collect)
    Article |> dec(article, :collect_count)

    conn
    |> put_flash(:info, "取消点赞成功.")
    |> redirect(to: article_path(conn, :show, article))
  end
end
