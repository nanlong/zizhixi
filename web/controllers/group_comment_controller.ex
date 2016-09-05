defmodule Zizhixi.GroupCommentController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{GroupPost, GroupComment}

  import Zizhixi.Sqlalchemy, only: [set: 4, inc: 3]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.GuardianErrorHandler]
    when action in [:create, :delete]

  plug Zizhixi.VerifyRequest, [model: GroupComment, action: "is_owner"]
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
      {:ok, _group_comment} ->
        GroupPost |> inc(post, :comment_count)
        conn |> put_flash(:info, "Group comment created successfully.")
      {:error, _changeset} ->
        conn |> put_flash(:danger, "Group comment created faild.")
    end

    conn |> redirect(to: group_post_path(conn, :show, post))
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
