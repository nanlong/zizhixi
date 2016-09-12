defmodule Zizhixi.GroupPostView do
  use Zizhixi.Web, :view

  alias Zizhixi.{Repo, GroupPostPraise, GroupPostWatch, GroupPostCollect}
  import Guardian.Plug, only: [authenticated?: 1, current_resource: 1]
  import Zizhixi.GroupView, only: [group_own?: 2]

  def praise_count(post) do
    cond do
      post.praise_count <= 0 -> "赞"
      post.praise_count > 0 -> "#{post.praise_count}个赞"
      true -> "赞"
    end
  end

  def praise?(conn, post) do
    if authenticated?(conn) do
      current_user = current_resource(conn)

      params = %{
        post_id: post.id,
        user_id: current_user.id
      }

      case Repo.get_by(GroupPostPraise, params) do
        nil -> false
        _ -> true
      end
    else
      false
    end
  end

  def watch?(conn, post) do
    if authenticated?(conn) do
      current_user = current_resource(conn)

      params = %{
        post_id: post.id,
        user_id: current_user.id
      }

      case Repo.get_by(GroupPostWatch, params) do
        nil -> false
        _ -> true
      end
    else
      false
    end
  end

  def collect?(conn, post) do
    if authenticated?(conn) do
      current_user = current_resource(conn)

      params = %{
        post_id: post.id,
        user_id: current_user.id
      }

      case Repo.get_by(GroupPostCollect, params) do
        nil -> false
        _ -> true
      end
    else
      false
    end
  end
end
