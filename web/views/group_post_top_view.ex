defmodule Zizhixi.GroupPostTopView do
  use Zizhixi.Web, :view

  def render("index.json", %{group_posts: group_posts}) do
    %{data: render_many(group_posts, Zizhixi.GroupPostTopView, "group_post_top.json")}
  end

  def render("show.json", %{group_post_top: group_post_top}) do
    %{data: render_one(group_post_top, Zizhixi.GroupPostTopView, "group_post_top.json")}
  end

  def render("group_post_top.json", %{group_post_top: group_post_top}) do
    %{id: group_post_top.id}
  end
end
