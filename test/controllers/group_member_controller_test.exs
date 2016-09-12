defmodule Zizhixi.GroupMemberControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.Group
  # alias Zizhixi.GroupMember

  def new_user(conn) do
    user_params = %{
      username: "newuser",
      email: "new@test.com",
      password: "123456"
    }
    post conn, user_path(conn, :create), user: user_params
  end

  test "lists all entries on index", %{conn: conn} do
    conn = conn
    |> Zizhixi.GroupControllerTest.create
    |> get(group_member_path(conn, :index, Repo.one(Group)))

    assert html_response(conn, 200) =~ "<html"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn
    |> Zizhixi.GroupControllerTest.create
    |> new_user
    |> post(group_member_path(conn, :create, Repo.one(Group)))

    assert Repo.one(Group).member_count == 2
  end

  test "creates resource and redirects when data is valid twice", %{conn: conn} do
    conn
    |> Zizhixi.GroupControllerTest.create
    |> new_user
    |> post(group_member_path(conn, :create, Repo.one(Group)))
    |> post(group_member_path(conn, :create, Repo.one(Group)))

    assert Repo.one(Group).member_count == 2
  end

  # test "deletes chosen resource", %{conn: conn} do
  #   conn = conn
  #   |> Zizhixi.GroupControllerTest.create
  #   |> new_user
  #   |> post(group_member_path(conn, :create, Repo.one(Group)))
  #   |> delete(group_member_path(conn, :delete, Repo.one(GroupMember)))
  #
  #   assert redirected_to(conn) == group_path(conn, :index)
  #   refute Repo.one(GroupMember)
  # end
end
