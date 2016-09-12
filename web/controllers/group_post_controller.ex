defmodule Zizhixi.GroupPostController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{Group, GroupPost, GroupComment, GroupMember}

  import Zizhixi.Ecto.Helpers, only: [inc: 3]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]
    when action in [:new, :create, :edit, :update, :delete]

  plug Zizhixi.Plug.VerifyRequest, [model: GroupPost, action: "is_owner"]
    when action in [:edit, :update, :delete]

  # todo: 验证用户是否为小组成员
  def new(conn, %{"group_id" => group_id}) do
    group = Repo.get!(Group, group_id)
    changeset = GroupPost.changeset(%GroupPost{})
    conn
    |> assign(:title, "#{group.name} - 发新帖")
    |> render("new.html", group: group, changeset: changeset)
  end

  # todo: 验证用户是否为小组成员
  def create(conn, %{"group_id" => group_id, "group_post" => group_post_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    group = Repo.get!(Group, group_id)

    params = group_post_params
    |> Map.put_new("group_id", group.id)
    |> Map.put_new("user_id", current_user.id)

    changeset = GroupPost.changeset(%GroupPost{}, params)

    case Repo.insert(changeset) do
      {:ok, _group_post} ->
        Group |> inc(group, :post_count)

        conn
        |> put_flash(:info, "发表帖子成功.")
        |> redirect(to: group_path(conn, :show, group))
      {:error, changeset} ->
        render(conn, "new.html", group: group, changeset: changeset)
    end
  end

  def show(conn, %{"group_id" => group_id, "id" => id}) do
    group = Repo.get!(Group, group_id)
    group_post = GroupPost
    |> preload([:user, :latest_user])
    |> Repo.get_by!(%{id: id})
    changeset = GroupComment.changeset(%GroupComment{})

    comments = GroupComment
    |> where(post_id: ^id)
    |> order_by(:inserted_at)
    |> preload([:user, :post])
    |> Repo.all

    member = case Guardian.Plug.current_resource(conn) do
      nil -> nil
      current_user -> Repo.get_by(GroupMember, %{group_id: group.id, user_id: current_user.id})
    end

    conn
    |> assign(:title, group_post.title)
    |> render("show.html", group: group, group_post: group_post,
      comments: comments, member: member, changeset: changeset)
  end

  def edit(conn, %{"group_id" => group_id, "id" => _id} = params) do
    group = Repo.get!(Group, group_id)
    group_post = Repo.get_by!(GroupPost, params)
    changeset = GroupPost.changeset(group_post)
    render(conn, "edit.html", group: group, group_post: group_post, changeset: changeset)
  end

  def update(conn, %{"group_id" => group_id, "id" => id, "group_post" => group_post_params}) do
    group = Repo.get!(Group, group_id)
    group_post = Repo.get_by!(GroupPost, %{id: id, group_id: group.id})
    changeset = GroupPost.changeset(group_post, group_post_params)

    case Repo.update(changeset) do
      {:ok, group_post} ->
        conn
        |> put_flash(:info, "Group post updated successfully.")
        |> redirect(to: group_post_path(conn, :show, group, group_post))
      {:error, changeset} ->
        render(conn, "edit.html", group: group, group_post: group_post, changeset: changeset)
    end
  end

  def delete(conn, %{"group_id" => group_id, "id" => _id} = params) do
    group = Repo.get!(Group, group_id)
    group_post = Repo.get_by!(GroupPost, params)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(group_post)

    conn
    |> put_flash(:info, "Group post deleted successfully.")
    |> redirect(to: group_post_path(conn, :index, group))
  end
end
