defmodule Zizhixi.ArticleUserView do
  use Zizhixi.Web, :view

  import Zizhixi.UserView, only: [follow?: 2]

  def tabs(conn, article_user) do
    article_user = Zizhixi.Repo.preload(article_user, :user)
    user = article_user.user

    [
      {
        "index",
        "天工个人主页",
        article_user_path(conn, :show, user.username)
      },
      {
        "publish",
        "发帖 (#{article_user.article_count})",
        article_user_path(conn, :show, user.username, tab: "publish")
      },
      {
        "comment",
        "回帖 (#{article_user.comment_count})",
        article_user_path(conn, :show, user.username, tab: "comment")
      },
      {
        "collect",
        "收藏 (#{article_user.collect_count})",
        article_user_path(conn, :show, user.username, tab: "collect")
      },
      {
        "praise",
        "赞过 (#{article_user.praise_count})",
        article_user_path(conn, :show, user.username, tab: "praise")
      },
    ]
  end
end
