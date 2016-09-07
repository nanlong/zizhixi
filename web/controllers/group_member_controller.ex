defmodule Zizhixi.GroupMemberController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{Group, GroupMember, JsonView}

  import Zizhixi.Ecto.Helpers, only: [inc: 3, dec: 3]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]
    when action in [:create, :delete]

  plug Zizhixi.Plug.VerifyRequest, [model: GroupMember, action: "is_owner"]
    when action in [:delete]

  def index(conn, %{"group_id" => _group_id}) do
    group_members = Repo.all(GroupMember)
    render(conn, "index.html", group_members: group_members)
  end

  def create(conn, %{"group_id" => group_id}) do
    current_user = Guardian.Plug.current_resource(conn)
    group = Repo.get!(Group, group_id)
    params = %{group_id: group.id, user_id: current_user.id}
    changeset = GroupMember.changeset(%GroupMember{}, params)

    cond do
      GroupMember |> Repo.get_by(params) ->
        conn |> json(%{status: 1})
      true ->
        case Repo.insert(changeset) do
          {:ok, _group_member} ->
            Group |> inc(group, :member_count)
            conn |> json(%{status: 1})
          {:error, changeset} ->
            conn
            |> put_status(400)
            |> render(JsonView, "error.json", changeset: changeset)
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)
    group_member = Repo.get_by!(GroupMember, %{id: id, user_id: current_user.id})
    group = Repo.get!(Group, group_member.group_id)
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(group_member)
    Group |> dec(group, :member_count)

    conn |> redirect(to: group_path(conn, :index))
  end
end
