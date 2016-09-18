defmodule Zizhixi.GroupUserControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.GroupUser
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, group_user_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing group users"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, group_user_path(conn, :new)
    assert html_response(conn, 200) =~ "New group user"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, group_user_path(conn, :create), group_user: @valid_attrs
    assert redirected_to(conn) == group_user_path(conn, :index)
    assert Repo.get_by(GroupUser, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, group_user_path(conn, :create), group_user: @invalid_attrs
    assert html_response(conn, 200) =~ "New group user"
  end

  test "shows chosen resource", %{conn: conn} do
    group_user = Repo.insert! %GroupUser{}
    conn = get conn, group_user_path(conn, :show, group_user)
    assert html_response(conn, 200) =~ "Show group user"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, group_user_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    group_user = Repo.insert! %GroupUser{}
    conn = get conn, group_user_path(conn, :edit, group_user)
    assert html_response(conn, 200) =~ "Edit group user"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    group_user = Repo.insert! %GroupUser{}
    conn = put conn, group_user_path(conn, :update, group_user), group_user: @valid_attrs
    assert redirected_to(conn) == group_user_path(conn, :show, group_user)
    assert Repo.get_by(GroupUser, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    group_user = Repo.insert! %GroupUser{}
    conn = put conn, group_user_path(conn, :update, group_user), group_user: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit group user"
  end

  test "deletes chosen resource", %{conn: conn} do
    group_user = Repo.insert! %GroupUser{}
    conn = delete conn, group_user_path(conn, :delete, group_user)
    assert redirected_to(conn) == group_user_path(conn, :index)
    refute Repo.get(GroupUser, group_user.id)
  end
end
