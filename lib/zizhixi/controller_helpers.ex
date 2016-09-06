defmodule Zizhixi.ControllerHelpers do
  use Phoenix.Controller
  import Plug.Conn

  def redirect_to(conn, default) do
    forwarding_url = get_session(conn, :forwarding_url) || default

    conn
    |> delete_session(:forwarding_url)
    |> redirect(to: forwarding_url)
  end
end
