defmodule Zizhixi.ViewHelpers do
  use Phoenix.HTML

  def from_now(time) do
    time
    |> Ecto.DateTime.to_erl
    |> Timex.from_now
  end

  def strftime(time, format \\ "{YYYY}-{0M}-{0D}") do
    time
    |> Ecto.DateTime.to_erl
    |> Timex.to_datetime("Etc/UTC")
    |> Timex.format!(format)
  end
end
