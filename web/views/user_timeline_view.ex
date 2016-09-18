defmodule Zizhixi.UserTimelineView do
  use Zizhixi.Web, :view

  def render("index.json", %{user_timelines: user_timelines}) do
    %{data: render_many(user_timelines, Zizhixi.UserTimelineView, "user_timeline.json")}
  end

  def render("show.json", %{user_timeline: user_timeline}) do
    %{data: render_one(user_timeline, Zizhixi.UserTimelineView, "user_timeline.json")}
  end

  def render("user_timeline.json", %{user_timeline: user_timeline}) do
    %{
      day: user_timeline.day,
      on: user_timeline.on,
      action: user_timeline.action,
      resource: user_timeline.resource,
      html: html(user_timeline),
      inserted_at: user_timeline.inserted_at
    }
  end

  def html(user_timeline) do
    "在#{user_timeline.on}#{user_timeline.action}#{user_timeline.resource}"
  end
end
