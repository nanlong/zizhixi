defmodule Zizhixi.AnswerControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.Answer
  @valid_attrs %{content: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, answer_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing answers"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, answer_path(conn, :new)
    assert html_response(conn, 200) =~ "New answer"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, answer_path(conn, :create), answer: @valid_attrs
    assert redirected_to(conn) == answer_path(conn, :index)
    assert Repo.get_by(Answer, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, answer_path(conn, :create), answer: @invalid_attrs
    assert html_response(conn, 200) =~ "New answer"
  end

  test "shows chosen resource", %{conn: conn} do
    answer = Repo.insert! %Answer{}
    conn = get conn, answer_path(conn, :show, answer)
    assert html_response(conn, 200) =~ "Show answer"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, answer_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    answer = Repo.insert! %Answer{}
    conn = get conn, answer_path(conn, :edit, answer)
    assert html_response(conn, 200) =~ "Edit answer"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    answer = Repo.insert! %Answer{}
    conn = put conn, answer_path(conn, :update, answer), answer: @valid_attrs
    assert redirected_to(conn) == answer_path(conn, :show, answer)
    assert Repo.get_by(Answer, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    answer = Repo.insert! %Answer{}
    conn = put conn, answer_path(conn, :update, answer), answer: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit answer"
  end

  test "deletes chosen resource", %{conn: conn} do
    answer = Repo.insert! %Answer{}
    conn = delete conn, answer_path(conn, :delete, answer)
    assert redirected_to(conn) == answer_path(conn, :index)
    refute Repo.get(Answer, answer.id)
  end
end
