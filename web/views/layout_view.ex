defmodule Zizhixi.LayoutView do
  use Zizhixi.Web, :view

  alias Zizhixi.{
    GroupController,
    GroupPostController,
    GroupCommentController,
    AskController,
    TutorialController,
  }

  def navigation(conn) do
    group_controllers = [GroupController, GroupPostController, GroupCommentController]
    ask_controllers = [AskController]
    tutorial_controllers = [TutorialController]
    [
      {group_controllers, "小组", group_path(conn, :index)},
      {ask_controllers, "问答", ask_path(conn, :index)},
      {tutorial_controllers, "天工", tutorial_path(conn, :index)},
      {[], "司南车", "/"},
      {[], "五杂市集", "/"},
    ]
  end
end
