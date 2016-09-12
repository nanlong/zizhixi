defmodule Zizhixi.GroupCommentView do
  use Zizhixi.Web, :view

  alias Zizhixi.{Repo, GroupCommentPraise}

  def praise_count(comment) do
    cond do
      comment.praise_count <= 0 -> "赞"
      comment.praise_count > 0 -> "#{comment.praise_count}个赞"
      true -> "赞"
    end
  end

  def praise?(comment, user) do
    params = %{
      comment_id: comment.id,
      user_id: user.id
    }

    case Repo.get_by(GroupCommentPraise, params) do
      nil -> false
      _ -> true
    end
  end
end
