defmodule Zizhixi.GroupController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{Group, GroupPost}

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]
    when action in [:new, :create, :edit, :update, :delete]

  plug Zizhixi.Plug.VerifyRequest, [model: Group, action: "is_owner"]
    when action in [:edit, :update, :delete]

  def index(conn, _params) do
    groups = Repo.all(Group)

    conn
    |> assign(:title, "自制系小组")
    |> render("index.html", groups: groups)
  end

  def new(conn, _params) do
    changeset = Group.changeset(%Group{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"group" => group_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    group_params = group_params |> Map.put_new("user_id", current_user.id)
    changeset = Group.changeset(%Group{}, group_params)

    case Repo.insert(changeset) do
      {:ok, _group} ->
        conn
        |> put_flash(:info, "Group created successfully.")
        |> redirect(to: group_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    group = Repo.get!(Group, id)
    posts = GroupPost |> where(group_id: ^group.id) |> Repo.all
    render(conn, "show.html", group: group, posts: posts)
  end

  def edit(conn, %{"id" => id}) do
    group = Repo.get!(Group, id)
    changeset = Group.changeset(group)
    render(conn, "edit.html", group: group, changeset: changeset)
  end

  def update(conn, %{"id" => id, "group" => group_params}) do
    group = Repo.get!(Group, id)
    changeset = Group.changeset(group, group_params)

    case Repo.update(changeset) do
      {:ok, group} ->
        conn
        |> put_flash(:info, "Group updated successfully.")
        |> redirect(to: group_path(conn, :show, group))
      {:error, changeset} ->
        render(conn, "edit.html", group: group, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    group = Repo.get!(Group, id)

    cond do
      group.member_count == 1 ->
        Repo.delete!(group)
        conn
        |> put_flash(:info, "Group deleted successfully.")
        |> redirect(to: group_path(conn, :index))
      true ->
        conn
        |> put_flash(:info, "已有成员加入,不能被删除.")
        |> redirect(to: group_path(conn, :show, group))
    end
  end
end
