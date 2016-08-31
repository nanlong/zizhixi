defmodule Zizhixi.PostCommentView do
  use Zizhixi.Web, :view

  def render("show.json", %{post_comment: post_comment}) do
    %{
      data: render_one(post_comment, __MODULE__, "detail.json")
    }
  end

  def render("detail.json", %{post_comment: post_comment}) do
    %{
      content: post_comment.content,
      inserted_at: post_comment.inserted_at,
      user: render_one(post_comment.user, Zizhixi.UserView, "detail.json")
    }
  end
end
