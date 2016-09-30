defmodule Zizhixi.AskUserView do
  use Zizhixi.Web, :view

  alias Zizhixi.{AskUser, UserFollowView}

  def tabs(conn, %AskUser{} = ask_user) do
    ask_user = Zizhixi.Repo.preload(ask_user, :user)
    user = ask_user.user

    [
      {
        "index",
        "问答主页",
        ask_user_path(conn, :show, user.username)
      },
      {
        "question",
        "提问 (#{ask_user.question_count})",
        ask_user_path(conn, :show, user.username, tab: "question")
      },
      {
        "answer",
        "回答 (#{ask_user.answer_count})",
        ask_user_path(conn, :show, user.username, tab: "answer")
      },
      {
        "collect",
        "收藏 (#{ask_user.collect_count})",
        ask_user_path(conn, :show, user.username, tab: "collect")
      }
    ]
  end
end
