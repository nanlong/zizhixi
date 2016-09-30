defmodule Zizhixi.ViewHelpers do
  use Phoenix.HTML

  import Guardian.Plug, only: [authenticated?: 1, current_resource: 1]

  def logged_in?(conn) do
    authenticated?(conn)
  end

  def admin?(conn) do
    {:ok, claims} = Guardian.Plug.claims(conn)
    claims
    |> Guardian.Permissions.from_claims(:admin)
    |> Guardian.Permissions.all?([:all], :admin)
  end

  def current_user(conn) do
    current_resource(conn)
  end

  def from_now(time) do
    time
    |> Timex.from_now
  end

  def strftime(time, format \\ "{YYYY}-{0M}-{0D}") do
    time
    |> Timex.to_datetime("Etc/UTC")
    |> Timex.format!(format)
  end



  def highlight(varable, value, class, default \\ "") do
    " " <> cond do
      varable == value -> class
      true -> default
    end
  end
end
