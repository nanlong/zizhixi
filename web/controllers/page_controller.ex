defmodule Zizhixi.PageController do
  use Zizhixi.Web, :controller

  def index(conn, _params) do
    conn |> render("index.html")
  end
end
