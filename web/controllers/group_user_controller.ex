defmodule Zizhixi.GroupUserController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{User, Group, GroupUser, GroupMember, GroupPost, GroupComment,
    GroupPostCollect, GroupPostPraise}

  def show(conn, %{"username" => username, "tab" => "index"}) do
    user = Repo.get_by!(User, %{username: username})
    group_user = GroupUser.get(user.id)

    groups = Group
    |> join(:inner, [g], m in GroupMember, g.id == m.group_id and m.user_id == ^user.id)
    |> order_by([desc: :inserted_at])
    |> Repo.paginate(%{page: 1, page_size: 6})

    posts = GroupPost
    |> where(user_id: ^group_user.user_id)
    |> order_by([desc: :inserted_at])
    |> preload([:user, :topic, :group, :latest_user])
    |> Repo.paginate(%{page: 1, page_size: 3})

    praises = GroupPost
    |> join(:inner, [p], c in GroupPostPraise, c.user_id == ^user.id and c.post_id == p.id)
    |> order_by([desc: :inserted_at])
    |> preload([:user, :topic, :group, :latest_user])
    |> Repo.paginate(%{page: 1, page_size: 3})

    conn
    |> assign(:title, "#{user.username} 的小组主页")
    |> assign(:current_tab, "index")
    |> assign(:user, user)
    |> assign(:group_user, group_user)
    |> assign(:groups, groups)
    |> assign(:posts, posts)
    |> assign(:praises, praises)
    |> render("show.html")
  end

  def show(conn, %{"username" => username, "tab" => "join"} = params) do
    user = Repo.get_by!(User, %{username: username})
    group_user = GroupUser.get(user.id)

    pagination = Group
    |> join(:inner, [g], m in GroupMember, g.id == m.group_id and m.user_id == ^user.id)
    |> order_by([desc: :inserted_at])
    |> Repo.paginate(params)

    conn
    |> assign(:title, "#{user.username} 加入的小组")
    |> assign(:current_tab, "join")
    |> assign(:user, user)
    |> assign(:group_user, group_user)
    |> assign(:pagination, pagination)
    |> render("show-group.html")
  end

  def show(conn, %{"username" => username, "tab" => "publish"} = params) do
    user = Repo.get_by!(User, %{username: username})
    group_user = GroupUser.get(user.id)

    pagination = GroupPost
    |> where(user_id: ^group_user.user_id)
    |> order_by([desc: :inserted_at])
    |> preload([:user, :topic, :group, :latest_user])
    |> Repo.paginate(params)

    conn
    |> assign(:title, "#{user.username} 的发帖")
    |> assign(:current_tab, "publish")
    |> assign(:user, user)
    |> assign(:group_user, group_user)
    |> assign(:pagination, pagination)
    |> render("show-post.html")
  end

  def show(conn, %{"username" => username, "tab" => "comment"} = params) do
    user = Repo.get_by!(User, %{username: username})
    group_user = GroupUser.get(user.id)

    pagination = GroupComment
    |> where(user_id: ^user.id)
    |> order_by([desc: :inserted_at])
    |> preload([:user, :post])
    |> Repo.paginate(params)

    conn
    |> assign(:title, "#{user.username} 的回帖")
    |> assign(:current_tab, "comment")
    |> assign(:user, user)
    |> assign(:group_user, group_user)
    |> assign(:pagination, pagination)
    |> render("show-comment.html")
  end

  def show(conn, %{"username" => username, "tab" => "collect"} = params) do
    user = Repo.get_by!(User, %{username: username})
    group_user = GroupUser.get(user.id)

    pagination = GroupPost
    |> join(:inner, [p], c in GroupPostCollect, c.user_id == ^user.id and c.post_id == p.id)
    |> order_by([desc: :inserted_at])
    |> preload([:user, :topic, :group, :latest_user])
    |> Repo.paginate(params)

    conn
    |> assign(:title, "#{user.username} 收藏的帖子")
    |> assign(:current_tab, "collect")
    |> assign(:user, user)
    |> assign(:group_user, group_user)
    |> assign(:pagination, pagination)
    |> render("show-collect.html")
  end

  def show(conn, %{"username" => username, "tab" => "praise"} = params) do
    user = Repo.get_by!(User, %{username: username})
    group_user = GroupUser.get(user.id)

    pagination = GroupPost
    |> join(:inner, [p], c in GroupPostPraise, c.user_id == ^user.id and c.post_id == p.id)
    |> order_by([desc: :inserted_at])
    |> preload([:user, :topic, :group, :latest_user])
    |> Repo.paginate(params)

    conn
    |> assign(:title, "#{user.username} 赞过的帖子")
    |> assign(:current_tab, "praise")
    |> assign(:user, user)
    |> assign(:group_user, group_user)
    |> assign(:pagination, pagination)
    |> render("show-collect.html")
  end

  def show(conn, %{"username" => username}) do
    show(conn, %{"username" => username, "tab" => "index"})
  end
end
