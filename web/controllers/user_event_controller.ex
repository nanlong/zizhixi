defmodule Zizhixi.UserEventController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{User, UserEvent}

  def index(conn, %{"user_username" => username}) do
    user = Repo.get_by!(User, %{username: username})

    upto = Timex.today
    since = Timex.shift(upto, years: -1, days: -1)

    user_events = UserEvent
    |> where([e], e.user_id == ^user.id and e.day >= ^since and e.day <= ^upto)
    |> order_by([:day])
    |> Repo.all

    render(conn, "index.json", user_events: user_events)
  end
end
