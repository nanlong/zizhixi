defmodule Zizhixi.GroupView do
  use Zizhixi.Web, :view

  alias Zizhixi.{Repo, GroupMember}
  import Guardian.Plug, only: [authenticated?: 1, current_resource: 1]

  def group_own?(conn, group) do
    if authenticated?(conn) do
      current_user = current_resource(conn)
      (current_user.id == group.user_id)
    else
      false
    end
  end

  def group_member?(conn, group) do
    if authenticated?(conn) do
      current_user = current_resource(conn)
      params = %{group_id: group.id, user_id: current_user.id}
      not (GroupMember |> Repo.get_by(params) |> is_nil)
    else
      false
    end
  end

  def tabs(conn) do
    case authenticated?(conn) do
      true ->
        [
          {"logged", "我的小组", group_path(conn, :index)},
          {"new", "小组新贴", group_path(conn, :index, tab: "new")},
          {"rank", "小组排行", group_path(conn, :index, tab: "rank")},
        ]
      false ->
        [
          {"new", "小组新贴", group_path(conn, :index, tab: "new")},
          {"rank", "小组排行", group_path(conn, :index, tab: "rank")},
        ]
    end
  end
end
