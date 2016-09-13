defmodule Zizhixi.PageController do
  use Zizhixi.Web, :controller

  def index(conn, _params) do
    conn |> render("index.html")
  end

  def upload(conn, %{"file" => file}) do
    {:ok, response} = Zizhixi.Qiniu.upload(file)
    conn |> json(response)
  end
end
