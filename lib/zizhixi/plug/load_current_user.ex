defmodule Zizhixi.Plug.LoadCurrentUser do
  @moduledoc """
  example:
    pipeline :browser_session do
      plug Guardian.Plug.VerifySession
      plug Guardian.Plug.LoadResource
      plug Zizhixi.Plug.LoadCurrentUser
    end

  at template:
    <%= @logged_in? %>
    <%= @current_user %>
  """
  import Guardian.Plug, only: [authenticated?: 1, current_resource: 1]
  import Plug.Conn, only: [assign: 3]

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> assign(:logged_in?, authenticated?(conn))
    |> assign(:current_user, current_resource(conn))
  end
end
