defmodule Zizhixi.GroupPostEliteControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.GroupPostElite
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, group_post_elite_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    group_post_elite = Repo.insert! %GroupPostElite{}
    conn = get conn, group_post_elite_path(conn, :show, group_post_elite)
    assert json_response(conn, 200)["data"] == %{"id" => group_post_elite.id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, group_post_elite_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, group_post_elite_path(conn, :create), group_post_elite: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(GroupPostElite, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, group_post_elite_path(conn, :create), group_post_elite: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    group_post_elite = Repo.insert! %GroupPostElite{}
    conn = put conn, group_post_elite_path(conn, :update, group_post_elite), group_post_elite: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(GroupPostElite, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    group_post_elite = Repo.insert! %GroupPostElite{}
    conn = put conn, group_post_elite_path(conn, :update, group_post_elite), group_post_elite: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    group_post_elite = Repo.insert! %GroupPostElite{}
    conn = delete conn, group_post_elite_path(conn, :delete, group_post_elite)
    assert response(conn, 204)
    refute Repo.get(GroupPostElite, group_post_elite.id)
  end
end
