defmodule Zizhixi.GroupCommentController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{GroupUser, GroupMember, GroupPost, GroupComment, UserTimeline,
    UserNotification}

  import Zizhixi.Ecto.Helpers, only: [update_field: 3, increment: 2]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]
    when action in [:create, :edit, :update, :delete]

  plug Zizhixi.Plug.VerifyRequest, [model: GroupComment, action: "is_owner"]
    when action in [:edit, :update, :delete]

  # todo: 验证当前用户是否为小组成员
  def create(conn, %{"group_post_id" => post_id, "group_comment" => comment_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    post = GroupPost |> preload([:user, :group]) |> Repo.get!(post_id)
    params = comment_params
    |> Map.put_new("post_id", post.id)
    |> Map.put_new("user_id", current_user.id)
    |> Map.put_new("index", post.comment_count + 1)
    changeset = GroupComment.changeset(%GroupComment{}, params)

    conn = case Repo.insert(changeset) do
      {:ok, group_comment} ->
        group_comment = Repo.preload(group_comment, :post)
        post |> increment(:comment_count)
        post |> update_field(:latest_inserted_at, group_comment.inserted_at)
        post |> update_field(:latest_user_id, group_comment.user_id)

        GroupUser.get(current_user.id) |> increment(:comment_count)
        Repo.get_by(GroupMember, %{group_id: post.group_id, user_id: current_user.id})
        |> increment(:comment_count)

        UserTimeline.create(conn,
          where: post.group,
          action: "回复了",
          what: group_comment
        )

        UserNotification.create(conn,
          user: post.user,
          who: current_user,
          where: post.group,
          action: "回复了",
          what: group_comment
        )

        GroupComment.at_user(conn, group_comment)

        conn |> put_flash(:info, "评论成功.")
      {:error, _changeset} ->
        conn |> put_flash(:error, "评论失败.")
    end

    conn |> redirect(to: group_post_path(conn, :show, post))
  end

  def show(conn, %{"group_post_id" => post_id, "id" => id}) do
    post = Repo.get!(GroupPost, post_id)
    group = Repo.get!(Group, post.group_id)
    comment = Repo.get_by!(GroupComment, %{id: id, post_id: post_id})

    render(conn, "show.html", group: group, post: post, comment: comment)
  end

  def edit(conn, %{"id" => id}) do
    comment = GroupComment |> preload([:post]) |> Repo.get!(id)
    changeset = GroupComment.changeset(comment)

    conn
    |> assign(:title, "编辑回复")
    |> render("edit.html", comment: comment, post: comment.post,  changeset: changeset)
  end

  def update(conn, %{"id" => id, "group_comment" => group_comment_params}) do
    comment = GroupComment |> preload([:post]) |> Repo.get!(id)
    changeset = GroupComment.changeset(comment, group_comment_params)

    case Repo.update(changeset) do
      {:ok, group_comment} ->
        conn
        |> put_flash(:info, "修改成功")
        |> redirect(to: group_post_path(conn, :show, group_comment.post))
      {:error, changeset} ->
        conn
        |> assign(:title, "编辑回复")
        |> render("edit.html", comment: comment, post: comment.post,  changeset: changeset)
    end

  end

  def delete(conn, %{"id" => id}) do
    comment = Repo.get!(GroupComment, id)
    post = Repo.get!(GroupPost, comment.post_id)

    comment |> update_field(:is_deleted, true)

    conn
    |> put_flash(:info, "评论删除成功.")
    |> redirect(to: group_post_path(conn, :show, post))
  end
end
