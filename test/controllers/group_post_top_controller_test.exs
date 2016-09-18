defmodule Zizhixi.GroupPostTopControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.GroupPostTop
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, group_post_top_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    group_post_top = Repo.insert! %GroupPostTop{}
    conn = get conn, group_post_top_path(conn, :show, group_post_top)
    assert json_response(conn, 200)["data"] == %{"id" => group_post_top.id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, group_post_top_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, group_post_top_path(conn, :create), group_post_top: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(GroupPostTop, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, group_post_top_path(conn, :create), group_post_top: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    group_post_top = Repo.insert! %GroupPostTop{}
    conn = put conn, group_post_top_path(conn, :update, group_post_top), group_post_top: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(GroupPostTop, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    group_post_top = Repo.insert! %GroupPostTop{}
    conn = put conn, group_post_top_path(conn, :update, group_post_top), group_post_top: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    group_post_top = Repo.insert! %GroupPostTop{}
    conn = delete conn, group_post_top_path(conn, :delete, group_post_top)
    assert response(conn, 204)
    refute Repo.get(GroupPostTop, group_post_top.id)
  end
end
