defmodule Zizhixi.LinkController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{Link, LinkCategory}

  import Zizhixi.Ecto.Helpers, only: [update_field: 3]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]
    when action in [:new, :create]

  plug Guardian.Plug.EnsurePermissions, [handler: Zizhixi.Guardian.ErrorHandler, admin: [:all]]
    when action in [:edit, :update, :delete]

  def index(conn, _params) do
    categories = LinkCategory
    |> Repo.all
    |> Repo.preload(links: from(l in Link, where: l.is_approved == true))

    categories = categories
    |> Enum.filter(fn category -> is_nil(category.category_id) end)
    |> Enum.map(fn parent ->
      childs = Enum.filter(categories, fn child ->
        child.category_id == parent.id
      end)
      {parent, childs}
    end)

    conn
    |> assign(:title, "司南车")
    |> assign(:categories, categories)
    |> render("index.html")
  end

  def new(conn, params) do
    changeset = Link.changeset(%Link{}, params)

    categories = LinkCategory
    |> Repo.all
    |> LinkCategory.generate

    conn
    |> assign(:title, "创建链接")
    |> assign(:categories, categories)
    |> assign(:changeset, changeset)
    |> render("new.html")
  end

  def create(conn, %{"link" => link_params}) do
    changeset = Link.changeset(%Link{}, link_params)

    case Repo.insert(changeset) do
      {:ok, _link} ->
        conn
        |> put_flash(:info, "链接添加成功，等待审核.")
        |> redirect(to: link_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    link = Repo.get!(Link, id)
    changeset = Link.changeset(link)
    categories = LinkCategory
    |> Repo.all
    |> LinkCategory.generate

    conn
    |> assign(:title, "编辑分类")
    |> assign(:link, link)
    |> assign(:categories, categories)
    |> assign(:changeset, changeset)
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "link" => %{"is_approved" => is_approved}}) do
    Repo.get!(Link, id)
    |> update_field(:is_approved, is_approved == "true")

    conn
    |> put_flash(:info, "操作成功.")
    |> redirect(to: link_category_path(conn, :index))
  end

  def update(conn, %{"id" => id, "link" => link_params}) do
    link = Repo.get!(Link, id)
    changeset = Link.changeset(link, link_params)

    case Repo.update(changeset) do
      {:ok, _link_category} ->
        conn
        |> put_flash(:info, "编辑成功.")
        |> redirect(to: link_category_path(conn, :index))
      {:error, changeset} ->
        categories = LinkCategory
        |> Repo.all
        |> LinkCategory.generate

        conn
        |> assign(:title, "编辑分类")
        |> assign(:link, link)
        |> assign(:categories, categories)
        |> assign(:changeset, changeset)
        |> render("edit.html")
    end
  end

  def delete(conn, %{"id" => id}) do
    link = Repo.get!(Link, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(link)

    conn
    |> put_flash(:info, "链接删除成功.")
    |> redirect(to: link_category_path(conn, :index))
  end
end
