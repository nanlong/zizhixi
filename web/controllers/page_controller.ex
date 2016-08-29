defmodule Zizhixi.PageController do
  use Zizhixi.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
