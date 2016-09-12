defmodule Zizhixi.Controller.Helpers do
  use Phoenix.Controller
  import Plug.Conn

  def redirect_to(conn, default) do
    redirect_url = get_session(conn, :forwarding_url) || Map.get(conn.params, "next") || default

    conn
    |> delete_session(:forwarding_url)
    |> redirect(to: redirect_url)
  end
end
