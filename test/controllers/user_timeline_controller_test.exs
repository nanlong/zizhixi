defmodule Zizhixi.UserTimelineControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.UserTimeline
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_timeline_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    user_timeline = Repo.insert! %UserTimeline{}
    conn = get conn, user_timeline_path(conn, :show, user_timeline)
    assert json_response(conn, 200)["data"] == %{"id" => user_timeline.id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_timeline_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_timeline_path(conn, :create), user_timeline: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(UserTimeline, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_timeline_path(conn, :create), user_timeline: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user_timeline = Repo.insert! %UserTimeline{}
    conn = put conn, user_timeline_path(conn, :update, user_timeline), user_timeline: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(UserTimeline, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user_timeline = Repo.insert! %UserTimeline{}
    conn = put conn, user_timeline_path(conn, :update, user_timeline), user_timeline: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    user_timeline = Repo.insert! %UserTimeline{}
    conn = delete conn, user_timeline_path(conn, :delete, user_timeline)
    assert response(conn, 204)
    refute Repo.get(UserTimeline, user_timeline.id)
  end
end
