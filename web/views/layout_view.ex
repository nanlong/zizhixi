defmodule Zizhixi.LayoutView do
  use Zizhixi.Web, :view

  alias Zizhixi.{
    GroupController,
    GroupPostController,
    GroupCommentController,
    AskController,
    TutorialController,
    LinkController,
    MarketController,
  }

  def navigation(conn) do
    group_controllers = [GroupController, GroupPostController, GroupCommentController]
    ask_controllers = [AskController]
    tutorial_controllers = [TutorialController]
    link_controllers = [LinkController]
    market_controllers = [MarketController]

    [
      {group_controllers, "小组", group_path(conn, :index)},
      {ask_controllers, "问答", ask_path(conn, :index)},
      {tutorial_controllers, "天工", tutorial_path(conn, :index)},
      {link_controllers, "司南车", link_path(conn, :index)},
      {market_controllers, "五杂市集", market_path(conn, :index)},
    ]
  end
end
