defmodule Zizhixi.Guardian.ErrorHandler do
  @behaviour Guardian.Plug.ErrorHandler

  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  alias Zizhixi.Router.Helpers

  def unauthenticated(conn, _params) do
    conn = cond do
      conn.method == "GET" ->
        conn |> Plug.Conn.put_session(:forwarding_url, conn.request_path)
      true -> conn
    end

    conn
    |> put_flash(:error, "哎哟～ 不登录不能操作啊！")
    |> redirect(to: Helpers.session_path(conn, :new))
  end

  def unauthorized(conn, _params) do
    conn
    |> Plug.Conn.put_status(401)
    |> put_flash(:error, "无权限操作!")
    |> redirect(to: Helpers.session_path(conn, :new))
  end
end
