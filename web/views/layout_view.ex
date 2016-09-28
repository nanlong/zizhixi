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

    QuestionAndAnswerController,
    QuestionController,

    MarketController,
  }

  def navigation(conn) do
    group_controllers = [GroupController, GroupUserController, GroupPostController,
      GroupCommentController, GroupTopicController, GroupMemberController]
    qa_controllers = [QuestionAndAnswerController, QuestionController]
    article_controllers = [ArticleController, ArticleUserController,
      ArticleSectionController, ArticleCommentController]
    link_controllers = [LinkController, LinkCategoryController]
    market_controllers = [MarketController]

    [
      {group_controllers, "小组", group_path(conn, :index)},
      {qa_controllers, "问答", question_and_answer_path(conn, :index)},
      {article_controllers, "天工", article_path(conn, :index)},
      {link_controllers, "司南车", link_path(conn, :index)},
      {market_controllers, "五杂市集", market_path(conn, :index)},
    ]
  end
end
