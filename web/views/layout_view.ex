defmodule Zizhixi.LayoutView do
  use Zizhixi.Web, :view

  alias Zizhixi.{
    GroupController,
    GroupPostController,
    GroupCommentController
  }

  def navigation(conn) do
    group_controllers = [GroupController, GroupPostController, GroupCommentController]

    [
      {group_controllers, "小组", group_path(conn, :index)},
      {[], "问答", "/"},
      {[], "天工", "/"},
      {[], "司南车", "/"},
      {[], "五杂市集", "/"},
    ]
  end
end
