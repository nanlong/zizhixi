defmodule Zizhixi.GroupPostView do
  use Zizhixi.Web, :view

  alias Zizhixi.{Repo, GroupPostPraise}

  def praise_count(post) do
    cond do
      post.praise_count <= 0 -> "赞"
      post.praise_count > 0 -> "#{post.praise_count}个赞"
      true -> "赞"
    end
  end

  def praise?(post, user) do
    params = %{
      post_id: post.id,
      user_id: user.id
    }

    case Repo.get_by(GroupPostPraise, params) do
      nil -> false
      _ -> true
    end
  end
end
