defmodule Zizhixi.GroupController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{Group, GroupMember, GroupPost}

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]
    when action in [:new, :create, :edit, :update, :delete]

  plug Zizhixi.Plug.VerifyRequest, [model: Group, action: "is_owner"]
    when action in [:edit, :update, :delete]

  def index(conn, %{"tab" => "my"} = params) do
    case Guardian.Plug.authenticated?(conn) do
      true ->
        current_user = Guardian.Plug.current_resource(conn)

        pagination = (from p in GroupPost,
          join: g in Group, on: p.group_id == g.id,
          join: m in GroupMember, on: g.id == m.group_id and m.user_id == ^current_user.id,
          order_by: [desc: :latest_inserted_at, desc: :inserted_at],
          preload: [:group, :user, :latest_user])
          |> Repo.paginate(params)

        groups = (from g in Group,
          join: m in GroupMember, on: g.id == m.group_id and m.user_id == ^current_user.id)
          |> Repo.all

        conn
        |> assign(:title, "我的小组帖子")
        |> assign(:current_tab, "my")
        |> render("index-my.html", groups: groups, pagination: pagination)
      false ->
        conn |> redirect(to: group_path(conn, :index, tab: "new"))
    end
  end

  def index(conn, %{"tab" => "new"} = params) do
    pagination = (from p in GroupPost,
      order_by: [desc: :inserted_at],
      preload: [:group, :user, :latest_user])
      |> Repo.paginate(params)

    conn
    |> assign(:title, "小组新帖")
    |> assign(:current_tab, "new")
    |> render("index-new.html", pagination: pagination)
  end

  def index(conn, %{"tab" => "rank"} = params) do
    groups = Group
    |> order_by(desc: :member_count, asc: :inserted_at)
    |> limit(50)
    |> Repo.all

    conn
    |> assign(:title, "小组排行")
    |> assign(:current_tab, "rank")
    |> render("index-rank.html", groups: groups)
  end

  def index(conn, _params) do
    index(conn, %{"tab" => "my"})
  end

  def new(conn, _params) do
    changeset = Group.changeset(%Group{})

    conn
    |> assign(:title, "创建小组")
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"group" => group_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    group_params = group_params |> Map.put_new("user_id", current_user.id)
    changeset = Group.changeset(%Group{}, group_params)

    case Repo.insert(changeset) do
      {:ok, group} ->
        Repo.insert(%GroupMember{group_id: group.id, user_id: current_user.id})

        conn
        |> put_flash(:info, "小组创建成功.")
        |> redirect(to: group_path(conn, :show, group))
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id} = params) do
    group = Group
    |> preload([:user])
    |> Repo.get!(id)

    group_members = GroupMember
    |> where(group_id: ^id)
    |> where([m], m.user_id != ^group.user_id)
    |> order_by([:inserted_at])
    |> preload([:user])
    |> Repo.paginate(%{page: 1})

    pagination = GroupPost
    |> where(group_id: ^group.id)
    |> order_by([desc: :latest_inserted_at, desc: :inserted_at])
    |> preload([:user, :latest_user])
    |> Repo.paginate(params)

    conn
    |> assign(:title, group.name)
    |> render("show.html",
      group: group,
      group_members: group_members,
      pagination: pagination)
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
        |> put_flash(:info, "小组信息编辑成功.")
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
