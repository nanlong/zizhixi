defmodule Zizhixi.PageController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{Qiniu}

  def index(conn, _params) do
    # IO.inspect AliyunDirectMail.Mail.single_send(
    #   account_name: "noreply@mail.zizhixi.com",
    #   to_address: "200006506@qq.com",
    #   subject: "第一次邮件",
    #   html_body: "第一次邮件"
    # )
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
