defmodule Zizhixi.GroupController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{Group, GroupUser, GroupTopic, GroupMember, GroupPost}
  import Zizhixi.Ecto.Helpers, only: [increment: 2]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]
    when action in [:new, :create, :edit, :update, :delete]

  plug Zizhixi.Plug.VerifyRequest, [model: Group, action: "is_owner"]
    when action in [:edit, :update, :delete]

  def index(conn, %{"tab" => "my"} = params) do
    case Guardian.Plug.authenticated?(conn) do
      true ->
        current_user = Guardian.Plug.current_resource(conn)

        group_user = GroupUser.get(current_user.id)

        pagination = (from p in GroupPost,
          join: g in Group, on: p.group_id == g.id,
          join: m in GroupMember, on: g.id == m.group_id and m.user_id == ^current_user.id,
          order_by: [desc: :latest_inserted_at, desc: :inserted_at],
          preload: [:topic, :group, :user, :latest_user])
          |> Repo.paginate(params)

        groups = (from g in Group,
          join: m in GroupMember, on: g.id == m.group_id and m.user_id == ^current_user.id)
          |> Repo.all

        groups_created = Enum.filter(groups, fn group -> group.user_id == current_user.id end)
        groups_joined = Enum.filter(groups, fn group -> group.user_id != current_user.id end)

        conn
        |> assign(:title, "我的小组帖子")
        |> assign(:current_tab, "my")
        |> assign(:groups, groups)
        |> assign(:group_user, group_user)
        |> assign(:groups_created, groups_created)
        |> assign(:groups_joined, groups_joined)
        |> assign(:pagination, pagination)
        |> render("index-my.html")
      false ->
        conn |> redirect(to: group_path(conn, :index, tab: "new"))
    end
  end

  def index(conn, %{"tab" => "new"} = params) do
    pagination = (from p in GroupPost,
      order_by: [desc: :inserted_at],
      preload: [:topic, :group, :user, :latest_user])
      |> Repo.paginate(params)

    conn
    |> assign(:title, "小组新帖")
    |> assign(:current_tab, "new")
    |> render("index-new.html", pagination: pagination)
  end

  def index(conn, %{"tab" => "rank"}) do
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

        GroupUser.get(current_user.id) |> increment(:group_count)

        conn
        |> put_flash(:info, "小组创建成功.")
        |> redirect(to: group_path(conn, :show, group))
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id, "tab" => tab} = params) do
    group = Group
    |> preload([:user])
    |> Repo.get!(id)

    group_members = GroupMember
    |> where(group_id: ^id)
    |> where([m], m.user_id != ^group.user_id)
    |> order_by([:inserted_at])
    |> preload([:user])
    |> Repo.paginate(%{page: 1})

    group_topics = GroupTopic
    |> where(group_id: ^id)
    |> order_by([:sorted, :inserted_at])
    |> Repo.all

    query = case tab do
      "全部" -> GroupPost |> order_by([desc: :is_top, desc: :latest_inserted_at, desc: :inserted_at])
      # "热门" -> GroupPost
      "精华" -> GroupPost |> where(is_elite: true)
      _ -> GroupPost |> join(:inner, [p], t in GroupTopic, p.topic_id == t.id and t.name == ^tab)
    end

    pagination = query
    |> where(group_id: ^group.id)
    |> order_by([desc: :latest_inserted_at, desc: :inserted_at])
    |> preload([:topic, :user, :latest_user])
    |> Repo.paginate(params)

    default_tabs = [
      {"全部", "全部", group_path(conn, :show, group, tab: "全部")},
      # {"热门", "热门", group_path(conn, :show, group, tab: "热门")},
      {"精华", "精华", group_path(conn, :show, group, tab: "精华")},
    ]

    group_topics_tabs = Enum.map(group_topics, fn topic ->
      {topic.name, topic.name, group_path(conn, :show, group, tab: topic.name)}
    end)

    conn
    |> assign(:title, group.name)
    |> assign(:current_tab, tab)
    |> render("show.html",
      group: group,
      group_members: group_members,
      tabs: default_tabs ++ group_topics_tabs,
      pagination: pagination)
  end

  def show(conn, %{"id" => id}) do
    show(conn, %{"id" => id, "tab" => "全部"})
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
        |> put_flash(:info, "小组删除成功.")
        |> redirect(to: group_path(conn, :index))
      true ->
        conn
        |> put_flash(:info, "已有成员加入,不能被删除.")
        |> redirect(to: group_path(conn, :show, group))
    end
  end
end
