defmodule Zizhixi.LayoutView do
  use Zizhixi.Web, :view

  alias Zizhixi.{
    GroupController,
    GroupPostController,
    GroupCommentController,
    GroupUserController,
    GroupTopicController,
    GroupMemberController,

    ArticleController,
    ArticleUserController,
    ArticleSectionController,
    ArticleCommentController,

    LinkController,
    LinkCategoryController,

    AskController,
    AskQuestionController,
    AskQuestionWatchController,
    AskUserController,

    MarketController,
  }

  def navigation(conn) do
    group_controllers = [GroupController, GroupUserController, GroupPostController,
      GroupCommentController, GroupTopicController, GroupMemberController]
    ask_controllers = [AskController, AskQuestionController,
      AskQuestionWatchController, AskUserController]
    article_controllers = [ArticleController, ArticleUserController,
      ArticleSectionController, ArticleCommentController]
    link_controllers = [LinkController, LinkCategoryController]
    market_controllers = [MarketController]

    [
      {group_controllers, "小组", group_path(conn, :index)},
      {ask_controllers, "问答", ask_path(conn, :index)},
      {article_controllers, "天工", article_path(conn, :index)},
      {link_controllers, "司南车", link_path(conn, :index)},
      {market_controllers, "五杂市集", market_path(conn, :index)},
    ]
  end
end
