defmodule Zizhixi.GroupCommentController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{GroupPost, GroupComment}

  import Zizhixi.Ecto.Helpers, only: [set: 4, inc: 3]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]
    when action in [:create, :delete]

  plug Zizhixi.Plug.VerifyRequest, [model: GroupComment, action: "is_owner"]
    when action in [:delete]

  # todo: 验证当前用户是否为小组成员
  def create(conn, %{"group_post_id" => post_id, "group_comment" => comment_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    post = Repo.get!(GroupPost, post_id)
    params = comment_params
    |> Map.put_new("post_id", post.id)
    |> Map.put_new("user_id", current_user.id)
    changeset = GroupComment.changeset(%GroupComment{}, params)

    conn = case Repo.insert(changeset) do
      {:ok, group_comment} ->
        GroupPost |> inc(post, :comment_count)
        GroupPost |> set(post, :latest_inserted_at, group_comment.inserted_at)
        GroupPost |> set(post, :latest_user_id, group_comment.user_id)

        conn |> put_flash(:info, "评论成功.")
      {:error, _changeset} ->
        conn |> put_flash(:error, "评论失败.")
    end

    conn |> redirect(to: group_post_path(conn, :show, post.group_id, post))
  end

  def show(conn, %{"group_post_id" => post_id, "id" => id}) do
    post = Repo.get!(GroupPost, post_id)
    group = Repo.get!(Group, post.group_id)
    comment = Repo.get_by!(GroupComment, %{id: id, post_id: post_id})

    render(conn, "show.html", group: group, post: post, comment: comment)
  end

  def delete(conn, %{"id" => id}) do
    comment = Repo.get!(GroupComment, id)

    GroupComment |> set(comment, :is_deleted, true)

    conn
    |> put_flash(:info, "Group comment deleted successfully.")
    |> redirect(to: group_post_path(conn, :show, comment.post_id))
  end
end
