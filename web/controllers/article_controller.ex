defmodule Zizhixi.ArticleController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{Article, ArticleSection, ArticleComment}

  import Guardian.Plug, only: [current_resource: 1]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]
    when action in [:new, :create, :update, :delete]

  plug Zizhixi.Plug.VerifyRequest, [model: Article, action: "is_owner"]
    when action in [:edit, :update, :delete]

  def index(conn, params) do
    pagination = Article
    |> order_by([desc: :inserted_at])
    |> preload([:user])
    |> Repo.paginate(params)

    conn
    |> assign(:title, "天工")
    |> assign(:pagination, pagination)
    |> render("index.html")
  end

  def new(conn, _params) do
    changeset = Article.changeset(%Article{})

    conn
    |> assign(:title, "天工发帖")
    |> assign(:changeset, changeset)
    |> render("new.html")
  end

  def create(conn, %{"article" => article_params}) do
    current_user = current_resource(conn)

    params = article_params
    |> Map.put_new("user_id", current_user.id)

    changeset = Article.changeset(%Article{}, params)

    case Repo.insert(changeset) do
      {:ok, _article} ->
        conn
        |> put_flash(:info, "发帖成功.")
        |> redirect(to: article_path(conn, :index))
      {:error, changeset} ->
        conn
        |> assign(:title, "天工发帖")
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end

  def show(conn, %{"id" => id}) do
    article = Article
    |> preload([:user])
    |> Repo.get!(id)
    |> Repo.preload(sections: from(ArticleSection, order_by: [:inserted_at]))

    article_comments = ArticleComment
    |> where(article_id: ^id)
    |> preload([:user])
    |> order_by([asc: :inserted_at])
    |> Repo.all

    changeset = ArticleComment.changeset(%ArticleComment{})

    conn
    |> assign(:title, article.title)
    |> assign(:article, article)
    |> assign(:article_comments, article_comments)
    |> assign(:changeset, changeset)
    |> render("show.html")
  end

  def edit(conn, %{"id" => id}) do
    article = Repo.get!(Article, id)
    changeset = Article.changeset(article)

    conn
    |> assign(:title, "编辑")
    |> assign(:article, article)
    |> assign(:changeset, changeset)
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "article" => article_params}) do
    article = Repo.get!(Article, id)
    changeset = Article.changeset(article, article_params)

    case Repo.update(changeset) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "更新成功.")
        |> redirect(to: article_path(conn, :show, article))
      {:error, changeset} ->
        conn
        |> assign(:title, "编辑")
        |> assign(:article, article)
        |> assign(:changeset, changeset)
        |> render("edit.html")
    end
  end

  def delete(conn, %{"id" => id}) do
    article = Repo.get!(Article, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(article)

    conn
    |> put_flash(:info, "删除成功.")
    |> redirect(to: article_path(conn, :index))
  end
end
