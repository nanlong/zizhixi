defmodule Zizhixi.AskView do
  use Zizhixi.Web, :view

  def tabs(conn) do
    [
      {"index", "最新问题", ask_path(conn, :index)},
      {"answer", "等待回答", ask_path(conn, :index, tab: "answer")}
    ]
  end
end
