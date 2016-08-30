defmodule Zizhixi.VerifyRequest do
  import Plug.Conn
  import Phoenix.Controller, only: [text: 2]
  alias Zizhixi.Repo

  def init(opts), do: opts

  def call(conn, [model: model, action: "is_owner"]) do
    case Guardian.Plug.authenticated?(conn) do
      true ->
        current_user = Guardian.Plug.current_resource(conn)
        resource = Repo.get!(model, conn.params["id"])

        case current_user.id != resource.user_id do
          true -> conn |> put_status(401) |> text("401 Unauthorized")
          false -> conn
        end

      false -> conn
    end
  end

  def call(conn, _opts), do: conn

end
