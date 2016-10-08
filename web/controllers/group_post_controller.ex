defmodule Zizhixi.GroupPostController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{Group, GroupUser, GroupMember, GroupTopic, GroupPost, GroupPostPV,
    GroupComment, UserTimeline}

  import Guardian.Plug, only: [current_resource: 1]
  import Zizhixi.Ecto.Helpers, only: [increment: 2]
  import Zizhixi.GroupView, only: [group_member?: 2]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]
    when action in [:new, :create, :edit, :update, :delete]

  plug Zizhixi.Plug.VerifyRequest, [model: GroupPost, action: "is_owner"]
    when action in [:edit, :update, :delete]

  def new(conn, %{"group_id" => group_id}) do
    group = Repo.get!(Group, group_id)

    if not group_member?(conn, group) do
      raise Phoenix.NotAcceptableError
    end

    group_topics = GroupTopic
    |> where(group_id: ^group_id)
    |> order_by([:sorted, :inserted_at])
    |> Repo.all

    changeset = GroupPost.changeset(%GroupPost{})

    conn
    |> assign(:title, "#{group.name} - 发新帖")
    |> render("new.html", group: group, group_topics: group_topics, changeset: changeset)
  end

  def create(conn, %{"group_id" => group_id, "group_post" => group_post_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    group = Repo.get!(Group, group_id)

    if not group_member?(conn, group) do
      raise Phoenix.NotAcceptableError
    end

    params = group_post_params
    |> Map.put_new("group_id", group.id)
    |> Map.put_new("user_id", current_user.id)

    changeset = GroupPost.changeset(%GroupPost{}, params)

    case Repo.insert(changeset) do
      {:ok, group_post} ->
        group |> increment(:post_count)
        GroupUser.get(current_user.id) |> increment(:post_count)
        Repo.get_by(GroupMember, %{group_id: group.id, user_id: current_user.id})
        |> increment(:post_count)

        UserTimeline.create(conn,
          where: group,
          action: "发布了",
          what: group_post
        )

        conn
        |> put_flash(:info, "发表帖子成功.")
        |> redirect(to: group_path(conn, :show, group))
      {:error, changeset} ->
        group_topics = GroupTopic
        |> where(group_id: ^group_id)
        |> order_by([:sorted, :inserted_at])
        |> Repo.all

        conn
        |> assign(:title, "#{group.name} - 发新帖")
        |> render("new.html", group: group, group_topics: group_topics, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user = current_resource(conn)

    group_post = GroupPost
    |> preload([:group, :user, :latest_user])
    |> Repo.get_by!(%{id: id})

    # 更新pv
    GroupPostPV.create(conn, group_post, current_user)

    group = group_post.group

    changeset = GroupComment.changeset(%GroupComment{})

    comments = GroupComment
    |> where(post_id: ^id)
    |> order_by(:inserted_at)
    |> preload([:user, :post])
    |> Repo.all

    conn
    |> assign(:title, group_post.title)
    |> render("show.html", group: group, group_post: group_post,
      comments: comments, changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    group_post = Repo.get!(GroupPost, id)
    changeset = GroupPost.changeset(group_post)

    group_topics = GroupTopic
    |> where(group_id: ^group_post.group_id)
    |> order_by([:sorted, :inserted_at])
    |> Repo.all

    conn
    |> assign(:group_post, group_post)
    |> assign(:group_topics, group_topics)
    |> assign(:changeset, changeset)
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "group_post" => group_post_params}) do
    group_post = Repo.get!(GroupPost, id)
    changeset = GroupPost.changeset(group_post, group_post_params)

    case Repo.update(changeset) do
      {:ok, group_post} ->
        conn
        |> put_flash(:info, "编辑成功.")
        |> redirect(to: group_post_path(conn, :show, group_post))
      {:error, changeset} ->
        group_topics = GroupTopic
        |> where(group_id: ^group_post.group_id)
        |> order_by([:sorted, :inserted_at])
        |> Repo.all

        conn
        |> assign(:group_post, group_post)
        |> assign(:group_topics, group_topics)
        |> assign(:changeset, changeset)
        |> render("edit.html")
    end
  end
end
