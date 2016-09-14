defmodule Zizhixi.UserEventControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.UserEvent
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_event_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    user_event = Repo.insert! %UserEvent{}
    conn = get conn, user_event_path(conn, :show, user_event)
    assert json_response(conn, 200)["data"] == %{"id" => user_event.id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_event_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_event_path(conn, :create), user_event: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(UserEvent, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_event_path(conn, :create), user_event: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user_event = Repo.insert! %UserEvent{}
    conn = put conn, user_event_path(conn, :update, user_event), user_event: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(UserEvent, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user_event = Repo.insert! %UserEvent{}
    conn = put conn, user_event_path(conn, :update, user_event), user_event: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    user_event = Repo.insert! %UserEvent{}
    conn = delete conn, user_event_path(conn, :delete, user_event)
    assert response(conn, 204)
    refute Repo.get(UserEvent, user_event.id)
  end
end
