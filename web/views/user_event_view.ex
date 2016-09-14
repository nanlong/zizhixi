defmodule Zizhixi.UserEventView do
  use Zizhixi.Web, :view

  def render("index.json", %{user_events: user_events}) do
    %{data: render_many(user_events, Zizhixi.UserEventView, "user_event.json")}
  end

  def render("show.json", %{user_event: user_event}) do
    %{data: render_one(user_event, Zizhixi.UserEventView, "user_event.json")}
  end

  def render("user_event.json", %{user_event: user_event}) do
    %{
      day: user_event.day,
      count: user_event.count
    }
  end
end
