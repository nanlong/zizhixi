defmodule Zizhixi.ArticleUserController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{User, ArticleUser, Article, ArticleComment, ArticleCollect, ArticlePraise}

  # 天工个人主页
  # 发帖 publish
  # 回帖 comment
  # 收藏 collect
  # 赞过 praise
  def show(conn, %{"username" => username, "tab" => "index"}) do
    user = Repo.get_by!(User, %{username: username})
    article_user = ArticleUser.get(user)

    publish = Article
    |> where(user_id: ^user.id)
    |> order_by([desc: :inserted_at])
    |> preload([:latest_user])
    |> Repo.paginate(%{page: 1, page_size: 3})

    comment = ArticleComment
    |> where(user_id: ^user.id)
    |> order_by([desc: :inserted_at])
    |> preload([:article, article: [:user, :latest_user]])
    |> Repo.paginate(%{page: 1, page_size: 3})

    collect = Article
    |> join(:inner, [a], c in ArticleCollect, c.user_id == ^user.id and c.article_id == a.id)
    |> order_by([_, c], [desc: c.inserted_at])
    |> preload([:user, :latest_user])
    |> Repo.paginate(%{page: 1, page_size: 3})

    praise = Article
    |> join(:inner, [a], p in ArticlePraise, p.user_id == ^user.id and p.article_id == a.id)
    |> order_by([_, p], [desc: p.inserted_at])
    |> preload([:user, :latest_user])
    |> Repo.paginate(%{page: 1, page_size: 3})

    conn
    |> assign(:title, user.username <> " 的天工个人主页")
    |> assign(:user, user)
    |> assign(:article_user, article_user)
    |> assign(:current_tab, "index")
    |> assign(:publish, publish)
    |> assign(:comment, comment)
    |> assign(:collect, collect)
    |> assign(:praise, praise)
    |> render("show-index.html")
  end

  def show(conn, %{"username" => username, "tab" => "publish"} = params) do
    user = Repo.get_by!(User, %{username: username})
    article_user = ArticleUser.get(user)

    pagination = Article
    |> where(user_id: ^user.id)
    |> order_by([desc: :inserted_at])
    |> preload([:latest_user])
    |> Repo.paginate(params)

    conn
    |> assign(:title, user.username <> " 的发帖")
    |> assign(:user, user)
    |> assign(:article_user, article_user)
    |> assign(:current_tab, "publish")
    |> assign(:pagination, pagination)
    |> render("show-publish.html")
  end

  def show(conn, %{"username" => username, "tab" => "comment"} = params) do
    user = Repo.get_by!(User, %{username: username})
    article_user = ArticleUser.get(user)

    pagination = ArticleComment
    |> where(user_id: ^user.id)
    |> order_by([desc: :inserted_at])
    |> preload([:article, article: [:user, :latest_user]])
    |> Repo.paginate(params)

    conn
    |> assign(:title, user.username <> " 的回帖")
    |> assign(:user, user)
    |> assign(:article_user, article_user)
    |> assign(:current_tab, "comment")
    |> assign(:pagination, pagination)
    |> render("show-comment.html")
  end

  def show(conn, %{"username" => username, "tab" => "collect"} = params) do
    user = Repo.get_by!(User, %{username: username})
    article_user = ArticleUser.get(user)

    pagination = Article
    |> join(:inner, [a], c in ArticleCollect, c.user_id == ^user.id and c.article_id == a.id)
    |> order_by([_, c], [desc: c.inserted_at])
    |> preload([:user, :latest_user])
    |> Repo.paginate(params)

    conn
    |> assign(:title, user.username <> " 收藏的文章")
    |> assign(:user, user)
    |> assign(:article_user, article_user)
    |> assign(:current_tab, "collect")
    |> assign(:pagination, pagination)
    |> render("show-collect.html")
  end

  def show(conn, %{"username" => username, "tab" => "praise"} = params) do
    user = Repo.get_by!(User, %{username: username})
    article_user = ArticleUser.get(user)

    pagination = Article
    |> join(:inner, [a], p in ArticlePraise, p.user_id == ^user.id and p.article_id == a.id)
    |> order_by([_, p], [desc: p.inserted_at])
    |> preload([:user, :latest_user])
    |> Repo.paginate(params)

    conn
    |> assign(:title, user.username <> " 赞过的文章")
    |> assign(:user, user)
    |> assign(:article_user, article_user)
    |> assign(:current_tab, "praise")
    |> assign(:pagination, pagination)
    |> render("show-praise.html")
  end

  def show(conn, %{"username" => username}) do
    show(conn, %{"username" => username, "tab" => "index"})
  end
end
