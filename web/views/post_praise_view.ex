defmodule Zizhixi.PostPraiseView do
  use Zizhixi.Web, :view

  def render("index.json", %{post_praises: post_praises}) do
    %{data: render_many(post_praises, Zizhixi.PostPraiseView, "post_praise.json")}
  end

  def render("show.json", %{post_praise: post_praise}) do
    %{data: render_one(post_praise, Zizhixi.PostPraiseView, "post_praise.json")}
  end

  def render("post_praise.json", %{post_praise: post_praise}) do
    %{id: post_praise.id}
  end
end
