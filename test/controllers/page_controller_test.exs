defmodule Zizhixi.PageControllerTest do
  use Zizhixi.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "<html"
  end
end
