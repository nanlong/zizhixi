defmodule Zizhixi.GroupCommentPraiseController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{Repo, GroupComment, GroupCommentPraise, UserNotification}

  import Guardian.Plug, only: [current_resource: 1]
  import Zizhixi.Ecto.Helpers, only: [increment: 2, decrement: 2]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]
    when action in [:create, :delete]

  def create(conn, %{"group_comment_id" => id}) do
    current_user = current_resource(conn)
    group_comment = GroupComment
    |> preload([:user, :post, post: :group])
    |> Repo.get!(id)

    params = %{
      comment_id: id,
      user_id: current_user.id
    }

    changeset = GroupCommentPraise.changeset(%GroupCommentPraise{}, params)

    conn = case Repo.insert(changeset) do
      {:ok, _group_comment_praise} ->
        group_comment |> increment(:praise_count)

        UserNotification.create(conn,
          user: group_comment.user,
          who: current_user,
          where: group_comment.post.group,
          action: "赞了",
          what: group_comment
        )

        conn |> put_flash(:info, "评论点赞成功.")
      {:error, _changeset} ->
        conn |> put_flash(:info, "评论点赞失败.")
    end

    conn |> redirect(to: group_post_path(conn, :show, group_comment.post_id))
  end

  def delete(conn, %{"group_comment_id" => id}) do
    current_user = current_resource(conn)
    group_comment = Repo.get!(GroupComment, id)

    params = %{
      comment_id: id,
      user_id: current_user.id
    }

    group_comment_praise = Repo.get_by!(GroupCommentPraise, params)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(group_comment_praise)
    group_comment |> decrement(:praise_count)

    conn |> put_flash(:info, "取消评论点赞成功.")
    |> redirect(to: group_post_path(conn, :show, group_comment.post_id))
  end
end
