defmodule Zizhixi.GroupMemberControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.GroupMember
  @valid_attrs %{
    group_id: "xxx",
    user_id: "xxx",
  }
  @invalid_attrs %{
    group_id: "",
    user_id: ""
  }

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, group_member_path(conn, :index)
    assert html_response(conn, 200) =~ "<html"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, group_member_path(conn, :create), group_member: @valid_attrs
    assert redirected_to(conn) == group_member_path(conn, :index)
    assert Repo.get_by(GroupMember, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, group_member_path(conn, :create), group_member: @invalid_attrs
    assert html_response(conn, 200) =~ "New group member"
  end

  # test "deletes chosen resource", %{conn: conn} do
  #   group_member = Repo.insert! %GroupMember{}
  #   conn = delete conn, group_member_path(conn, :delete, group_member)
  #   assert redirected_to(conn) == group_member_path(conn, :index)
  #   refute Repo.get(GroupMember, group_member.id)
  # end
end
