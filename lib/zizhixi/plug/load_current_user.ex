defmodule Zizhixi.Plug.LoadCurrentUser do
  import Guardian.Plug, only: [authenticated?: 1, current_resource: 1]
  import Plug.Conn, only: [assign: 3]

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> assign(:logged_in?, authenticated?(conn))
    |> assign(:current_user, current_resource(conn))
  end
end
