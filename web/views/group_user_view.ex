defmodule Zizhixi.GroupUserView do
  use Zizhixi.Web, :view

  import Zizhixi.UserView, only: [follow?: 2]
  
  def tabs(conn, group_user) do
    group_user = Zizhixi.Repo.preload(group_user, :user)
    user = group_user.user

    [
      {
        "index",
        "小组主页",
        group_user_path(conn, :show, user.username)
      },
      {
        "group",
        "加入的小组 (#{group_user.group_count})",
        group_user_path(conn, :show, user.username, tab: "group")
      },
      {
        "post",
        "发帖 (#{group_user.post_count})",
        group_user_path(conn, :show, user.username, tab: "post")
      },
      {
        "comment",
        "回帖 (#{group_user.comment_count})",
        group_user_path(conn, :show, user.username, tab: "comment")
      },
      {
        "collect",
        "收藏 (#{group_user.collect_count})",
        group_user_path(conn, :show, user.username, tab: "collect")
      },
      {
        "praise",
        "赞过 (#{group_user.praise_count})",
        group_user_path(conn, :show, user.username, tab: "praise")
      },
    ]
  end
end
