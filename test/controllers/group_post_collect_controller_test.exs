defmodule Zizhixi.GroupPostCollectControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.GroupPostCollect
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, group_post_collect_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing group post collects"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, group_post_collect_path(conn, :new)
    assert html_response(conn, 200) =~ "New group post collect"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, group_post_collect_path(conn, :create), group_post_collect: @valid_attrs
    assert redirected_to(conn) == group_post_collect_path(conn, :index)
    assert Repo.get_by(GroupPostCollect, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, group_post_collect_path(conn, :create), group_post_collect: @invalid_attrs
    assert html_response(conn, 200) =~ "New group post collect"
  end

  test "shows chosen resource", %{conn: conn} do
    group_post_collect = Repo.insert! %GroupPostCollect{}
    conn = get conn, group_post_collect_path(conn, :show, group_post_collect)
    assert html_response(conn, 200) =~ "Show group post collect"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, group_post_collect_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    group_post_collect = Repo.insert! %GroupPostCollect{}
    conn = get conn, group_post_collect_path(conn, :edit, group_post_collect)
    assert html_response(conn, 200) =~ "Edit group post collect"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    group_post_collect = Repo.insert! %GroupPostCollect{}
    conn = put conn, group_post_collect_path(conn, :update, group_post_collect), group_post_collect: @valid_attrs
    assert redirected_to(conn) == group_post_collect_path(conn, :show, group_post_collect)
    assert Repo.get_by(GroupPostCollect, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    group_post_collect = Repo.insert! %GroupPostCollect{}
    conn = put conn, group_post_collect_path(conn, :update, group_post_collect), group_post_collect: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit group post collect"
  end

  test "deletes chosen resource", %{conn: conn} do
    group_post_collect = Repo.insert! %GroupPostCollect{}
    conn = delete conn, group_post_collect_path(conn, :delete, group_post_collect)
    assert redirected_to(conn) == group_post_collect_path(conn, :index)
    refute Repo.get(GroupPostCollect, group_post_collect.id)
  end
end
