defmodule Zizhixi.ViewHelpers do
  use Phoenix.HTML

  def from_now(time) do
    time
    |> Timex.from_now
  end

  def strftime(time, format \\ "{YYYY}-{0M}-{0D}") do
    time
    |> Timex.to_datetime("Etc/UTC")
    |> Timex.format!(format)
  end

  def admin?(conn) do
    {:ok, claims} = Guardian.Plug.claims(conn)
    claims
    |> Guardian.Permissions.from_claims(:admin)
    |> Guardian.Permissions.all?([:all], :admin)
  end

  def highlight(varable, value, class, default \\ "") do
    " " <> cond do
      varable == value -> class
      true -> default
    end
  end
end
