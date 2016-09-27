defmodule Zizhixi.LinkController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{Link, LinkCategory}

  def index(conn, _params) do
    categories = LinkCategory
    |> Repo.all
    |> Repo.preload(links: from(l in Link))

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
        |> put_flash(:info, "Link created successfully.")
        |> redirect(to: link_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    link = Repo.get!(Link, id)
    render(conn, "show.html", link: link)
  end

  def edit(conn, %{"id" => id}) do
    link = Repo.get!(Link, id)
    changeset = Link.changeset(link)
    render(conn, "edit.html", link: link, changeset: changeset)
  end

  def update(conn, %{"id" => id, "link" => link_params}) do
    link = Repo.get!(Link, id)
    changeset = Link.changeset(link, link_params)

    case Repo.update(changeset) do
      {:ok, link} ->
        conn
        |> put_flash(:info, "Link updated successfully.")
        |> redirect(to: link_path(conn, :show, link))
      {:error, changeset} ->
        render(conn, "edit.html", link: link, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    link = Repo.get!(Link, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(link)

    conn
    |> put_flash(:info, "Link deleted successfully.")
    |> redirect(to: link_path(conn, :index))
  end
end
