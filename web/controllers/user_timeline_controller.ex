defmodule Zizhixi.UserTimelineController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{User, UserTimeline}

  def index(conn, %{"user_username" => username, "day" => day}) do
    user = Repo.get_by!(User, %{username: username})

    user_timelines = UserTimeline
    |> where(user_id: ^user.id)
    |> where(day: ^day)
    |> order_by([:inserted_at])
    |> Repo.all

    render(conn, "index.json", user_timelines: user_timelines)
  end

  def index(conn, %{"user_username" => username}) do
    index(conn, %{"user_username" => username, "day" => Timex.today})
  end
end
