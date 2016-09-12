defmodule Zizhixi.LayoutView do
  use Zizhixi.Web, :view

  alias Zizhixi.{
    GroupController,
    GroupPostController,
    GroupCommentController,
    AskController,
  }

  def navigation(conn) do
    group_controllers = [GroupController, GroupPostController, GroupCommentController]
    ask_controllers = [AskController]
    [
      {group_controllers, "小组", group_path(conn, :index)},
      {ask_controllers, "问答", ask_path(conn, :index)},
      {[], "天工", "/"},
      {[], "司南车", "/"},
      {[], "五杂市集", "/"},
    ]
  end
end
