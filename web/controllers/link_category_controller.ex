defmodule Zizhixi.LinkCategoryController do
  use Zizhixi.Web, :controller

  alias Zizhixi.LinkCategory

  plug Guardian.Plug.EnsurePermissions, handler: Zizhixi.Guardian.ErrorHandler, admin: [:all]

  def index(conn, _params) do
    link_categories = LinkCategory
    |> preload([:category])
    |> Repo.all

    conn
    |> assign(:title, "分类主页")
    |> assign(:link_categories, link_categories)
    |> render("index.html")
  end

  def new(conn, _params) do
    changeset = LinkCategory.changeset(%LinkCategory{})
    categories = LinkCategory.query |> Repo.all

    conn
    |> assign(:title, "创建分类")
    |> assign(:categories, categories)
    |> assign(:changeset, changeset)
    |> render("new.html")
  end

  def create(conn, %{"link_category" => link_category_params}) do
    changeset = LinkCategory.changeset(%LinkCategory{}, link_category_params)

    case Repo.insert(changeset) do
      {:ok, _link_category} ->
        conn
        |> put_flash(:info, "分类创建成功.")
        |> redirect(to: link_category_path(conn, :index))
      {:error, changeset} ->
        categories = LinkCategory.query |> Repo.all

        conn
        |> assign(:title, "创建分类")
        |> assign(:categories, categories)
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end

  def edit(conn, %{"id" => id}) do
    link_category = Repo.get!(LinkCategory, id)
    changeset = LinkCategory.changeset(link_category)
    categories = LinkCategory.query |> Repo.all

    conn
    |> assign(:title, "编辑分类")
    |> assign(:link_category, link_category)
    |> assign(:categories, categories)
    |> assign(:changeset, changeset)
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "link_category" => link_category_params}) do
    link_category = Repo.get!(LinkCategory, id)
    changeset = LinkCategory.changeset(link_category, link_category_params)

    case Repo.update(changeset) do
      {:ok, _link_category} ->
        conn
        |> put_flash(:info, "分类更新成功.")
        |> redirect(to: link_category_path(conn, :index))
      {:error, changeset} ->
        categories = LinkCategory.query |> Repo.all

        conn
        |> assign(:title, "编辑分类")
        |> assign(:link_category, link_category)
        |> assign(:categories, categories)
        |> assign(:changeset, changeset)
        |> render("edit.html")
    end
  end

  def delete(conn, %{"id" => id}) do
    link_category = Repo.get!(LinkCategory, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(link_category)

    conn
    |> put_flash(:info, "分类删除成功.")
    |> redirect(to: link_category_path(conn, :index))
  end
end
