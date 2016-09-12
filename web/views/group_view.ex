defmodule Zizhixi.GroupView do
  use Zizhixi.Web, :view

  import Guardian.Plug, only: [authenticated?: 1, current_resource: 1]

  def group_own?(conn, group) do
    if authenticated?(conn) do
      current_user = current_resource(conn)
      current_user.id == group.user_id
    else
      false
    end
  end

end
