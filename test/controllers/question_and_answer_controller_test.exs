defmodule Zizhixi.QuestionAndAnswerControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.QuestionAndAnswer
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, question_and_answer_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing questions"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, question_and_answer_path(conn, :new)
    assert html_response(conn, 200) =~ "New question and answer"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, question_and_answer_path(conn, :create), question_and_answer: @valid_attrs
    assert redirected_to(conn) == question_and_answer_path(conn, :index)
    assert Repo.get_by(QuestionAndAnswer, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, question_and_answer_path(conn, :create), question_and_answer: @invalid_attrs
    assert html_response(conn, 200) =~ "New question and answer"
  end

  test "shows chosen resource", %{conn: conn} do
    question_and_answer = Repo.insert! %QuestionAndAnswer{}
    conn = get conn, question_and_answer_path(conn, :show, question_and_answer)
    assert html_response(conn, 200) =~ "Show question and answer"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, question_and_answer_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    question_and_answer = Repo.insert! %QuestionAndAnswer{}
    conn = get conn, question_and_answer_path(conn, :edit, question_and_answer)
    assert html_response(conn, 200) =~ "Edit question and answer"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    question_and_answer = Repo.insert! %QuestionAndAnswer{}
    conn = put conn, question_and_answer_path(conn, :update, question_and_answer), question_and_answer: @valid_attrs
    assert redirected_to(conn) == question_and_answer_path(conn, :show, question_and_answer)
    assert Repo.get_by(QuestionAndAnswer, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    question_and_answer = Repo.insert! %QuestionAndAnswer{}
    conn = put conn, question_and_answer_path(conn, :update, question_and_answer), question_and_answer: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit question and answer"
  end

  test "deletes chosen resource", %{conn: conn} do
    question_and_answer = Repo.insert! %QuestionAndAnswer{}
    conn = delete conn, question_and_answer_path(conn, :delete, question_and_answer)
    assert redirected_to(conn) == question_and_answer_path(conn, :index)
    refute Repo.get(QuestionAndAnswer, question_and_answer.id)
  end
end
