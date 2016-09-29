defmodule Zizhixi.AnswerThankControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.AnswerThank
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, answer_thank_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    answer_thank = Repo.insert! %AnswerThank{}
    conn = get conn, answer_thank_path(conn, :show, answer_thank)
    assert json_response(conn, 200)["data"] == %{"id" => answer_thank.id,
      "answer_id" => answer_thank.answer_id,
      "user_id" => answer_thank.user_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, answer_thank_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, answer_thank_path(conn, :create), answer_thank: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(AnswerThank, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, answer_thank_path(conn, :create), answer_thank: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    answer_thank = Repo.insert! %AnswerThank{}
    conn = put conn, answer_thank_path(conn, :update, answer_thank), answer_thank: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(AnswerThank, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    answer_thank = Repo.insert! %AnswerThank{}
    conn = put conn, answer_thank_path(conn, :update, answer_thank), answer_thank: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    answer_thank = Repo.insert! %AnswerThank{}
    conn = delete conn, answer_thank_path(conn, :delete, answer_thank)
    assert response(conn, 204)
    refute Repo.get(AnswerThank, answer_thank.id)
  end
end
