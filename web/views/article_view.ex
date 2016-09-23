defmodule Zizhixi.ArticleView do
  use Zizhixi.Web, :view

  alias Zizhixi.{Repo, Article, ArticlePraise, ArticleCollect}
  import Guardian.Plug, only: [authenticated?: 1, current_resource: 1]

  def praise?(conn, article) do
    if authenticated?(conn) do
      current_user = current_resource(conn)

      params = %{
        article_id: article.id,
        user_id: current_user.id
      }

      case Repo.get_by(ArticlePraise, params) do
        nil -> false
        _ -> true
      end
    else
      false
    end
  end

  def praise_count(%Article{} = article) do
    praise_count(article.praise_count)
  end

  def praise_count(praise_count) when is_integer(praise_count) do
    case praise_count > 0 do
      true -> to_string(praise_count) <> "个赞"
      false -> "赞"
    end
  end

  def collect?(conn, article) do
    if authenticated?(conn) do
      current_user = current_resource(conn)

      params = %{
        article_id: article.id,
        user_id: current_user.id
      }

      case Repo.get_by(ArticleCollect, params) do
        nil -> false
        _ -> true
      end
    else
      false
    end
  end
end
