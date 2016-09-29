defmodule Zizhixi.QuestionWatchControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.QuestionWatch
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, question_watch_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    question_watch = Repo.insert! %QuestionWatch{}
    conn = get conn, question_watch_path(conn, :show, question_watch)
    assert json_response(conn, 200)["data"] == %{"id" => question_watch.id,
      "question_id" => question_watch.question_id,
      "user_id" => question_watch.user_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, question_watch_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, question_watch_path(conn, :create), question_watch: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(QuestionWatch, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, question_watch_path(conn, :create), question_watch: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    question_watch = Repo.insert! %QuestionWatch{}
    conn = put conn, question_watch_path(conn, :update, question_watch), question_watch: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(QuestionWatch, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    question_watch = Repo.insert! %QuestionWatch{}
    conn = put conn, question_watch_path(conn, :update, question_watch), question_watch: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    question_watch = Repo.insert! %QuestionWatch{}
    conn = delete conn, question_watch_path(conn, :delete, question_watch)
    assert response(conn, 204)
    refute Repo.get(QuestionWatch, question_watch.id)
  end
end
