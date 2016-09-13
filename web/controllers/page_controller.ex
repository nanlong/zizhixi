defmodule Zizhixi.PageController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{Qiniu}

  def index(conn, _params) do
    conn |> render("index.html")
  end

  def upload(conn, %{"file" => file}) do
    {:ok, response} = Qiniu.upload(file)
    conn |> json(response)
  end
end
