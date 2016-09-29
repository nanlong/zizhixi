defmodule Zizhixi.GroupMemberController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{Group, GroupUser, GroupMember, UserNotification}

  import Zizhixi.Ecto.Helpers, only: [increment: 2, decrement: 2]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]
    when action in [:create, :delete]

  import Zizhixi.Controller.Helpers, only: [redirect_to: 2]
  # plug Zizhixi.Plug.VerifyRequest, [model: GroupMember, action: "is_owner"]
  #   when action in [:delete]

  def index(conn, %{"group_id" => group_id}) do
    group = Group |> preload([:user]) |> Repo.get!(group_id)

    group_members  = GroupMember
    |> where([m], m.user_id != ^group.user_id)
    |> where(group_id: ^group_id)
    |> preload([:user])
    |> Repo.all

    conn
    |> assign(:title, "<#{group.name}>的成员列表")
    |> assign(:group, group)
    |> assign(:group_members, group_members)
    |> render("index.html")
  end

  def create(conn, %{"group_id" => group_id}) do
    current_user = Guardian.Plug.current_resource(conn)
    group = Group |> preload([:user]) |> Repo.get!(group_id)
    params = %{group_id: group.id, user_id: current_user.id}
    changeset = GroupMember.changeset(%GroupMember{}, params)

    conn = cond do
      GroupMember |> Repo.get_by(params) ->
        conn |> put_flash(:info, "你是本小组的成员，请不要重复加入")
      true ->
        case Repo.insert(changeset) do
          {:ok, _group_member} ->
            group |> increment(:member_count)

            GroupUser.get(current_user.id) |> increment(:group_count)

            UserNotification.create(conn,
              user: group.user,
              who: current_user,
              where: nil,
              action: "加入了",
              what: group
            )

            conn
            |> put_flash(:info, "成功加入 #{group.name} 小组")
          {:error, _changeset} ->
            conn
            |> put_flash(:error, "操作失败")
        end
    end

    conn |> redirect_to(group_path(conn, :show, group))
  end

  def delete(conn, %{"group_id" => group_id}) do
    current_user = Guardian.Plug.current_resource(conn)
    group = Repo.get!(Group, group_id)

    case group.user_id == current_user.id do
      true ->
        conn
        |> put_flash(:error, "创建者不能退出小组")
        |> redirect(to: group_path(conn, :show, group))

      false ->
        params = %{
          group_id: group_id,
          user_id: current_user.id
        }

        group_member = Repo.get_by!(GroupMember, params)

        # Here we use delete! (with a bang) because we expect
        # it to always work (and if it does not, it will raise).
        Repo.delete!(group_member)
        
        group |> decrement(:member_count)
        GroupUser.get(current_user.id) |> decrement(:group_count)

        conn
        |> put_flash(:info, "已退出 #{group.name} 小组")
        |> redirect_to(group_path(conn, :index))
    end
  end
end
