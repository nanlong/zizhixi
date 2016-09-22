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

  def editor_upload(conn, %{"file" => file}) do
    {:ok, response} = Qiniu.upload(file)
    conn |> json(%{
      success: true,
      file_path: response.url
    })
  end
end
