defmodule Zizhixi.ArticleSectionController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{Article, ArticleSection}

  import Guardian.Plug, only: [current_resource: 1]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]

  def new(conn, %{"article_id" => article_id}) do
    current_user = current_resource(conn)

    article = Article
    |> Repo.get_by!(%{id: article_id, user_id: current_user.id})
    |> Repo.preload(sections: from(ArticleSection, order_by: [:inserted_at]))

    changeset = ArticleSection.changeset(%ArticleSection{})

    conn
    |> assign(:title, "完善 " <> article.title)
    |> assign(:article, article)
    |> assign(:changeset, changeset)
    |> render("new.html")
  end

  def create(conn, %{"article_id" => article_id, "article_section" => article_section_params}) do
    current_user = current_resource(conn)

    article = Article
    |> Repo.get_by!(%{id: article_id, user_id: current_user.id})
    |> Repo.preload(sections: from(ArticleSection, order_by: [:inserted_at]))

    params = article_section_params
    |> Map.put_new("article_id", article_id)
    |> Map.put_new("user_id", current_user.id)

    changeset = ArticleSection.changeset(%ArticleSection{}, params)

    case Repo.insert(changeset) do
      {:ok, _article_section} ->
        conn
        |> put_flash(:info, "提交成功.")
        |> redirect(to: article_path(conn, :show, article))
      {:error, changeset} ->
        conn
        |> assign(:title, "完善 " <> article.title)
        |> assign(:article, article)
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end

  def edit(conn, %{"article_id" => article_id, "id" => id}) do
    current_user = current_resource(conn)
    article = Article
    |> Repo.get_by!(%{id: article_id, user_id: current_user.id})
    article_section = Repo.get!(ArticleSection, id)
    changeset = ArticleSection.changeset(article_section)

    conn
    |> assign(:title, "编辑")
    |> assign(:article, article)
    |> assign(:article_section, article_section)
    |> assign(:changeset, changeset)
    |> render("edit.html")
  end

  def update(conn, %{"article_id" => article_id, "id" => id, "article_section" => article_section_params}) do
    current_user = current_resource(conn)
    article = Article
    |> Repo.get_by!(%{id: article_id, user_id: current_user.id})
    article_section = Repo.get!(ArticleSection, id)
    changeset = ArticleSection.changeset(article_section, article_section_params)

    case Repo.update(changeset) do
      {:ok, _article_section} ->
        conn
        |> put_flash(:info, "更新成功.")
        |> redirect(to: article_path(conn, :show, article))
      {:error, changeset} ->
        conn
        |> assign(:title, "编辑")
        |> assign(:article, article)
        |> assign(:article_section, article_section)
        |> assign(:changeset, changeset)
        |> render("edit.html")
    end
  end
end
