defmodule Zizhixi.AnswerVoteControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.AnswerVote
  @valid_attrs %{status: true}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, answer_vote_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    answer_vote = Repo.insert! %AnswerVote{}
    conn = get conn, answer_vote_path(conn, :show, answer_vote)
    assert json_response(conn, 200)["data"] == %{"id" => answer_vote.id,
      "answer_id" => answer_vote.answer_id,
      "user_id" => answer_vote.user_id,
      "status" => answer_vote.status}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, answer_vote_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, answer_vote_path(conn, :create), answer_vote: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(AnswerVote, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, answer_vote_path(conn, :create), answer_vote: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    answer_vote = Repo.insert! %AnswerVote{}
    conn = put conn, answer_vote_path(conn, :update, answer_vote), answer_vote: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(AnswerVote, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    answer_vote = Repo.insert! %AnswerVote{}
    conn = put conn, answer_vote_path(conn, :update, answer_vote), answer_vote: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    answer_vote = Repo.insert! %AnswerVote{}
    conn = delete conn, answer_vote_path(conn, :delete, answer_vote)
    assert response(conn, 204)
    refute Repo.get(AnswerVote, answer_vote.id)
  end
end
