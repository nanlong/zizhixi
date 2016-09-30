defmodule Zizhixi.AskUserControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.AskUser
  @valid_attrs %{answer_count: 42, collect_count: "some content", question_count: 42, thank_count: "some content", vote_count: "some content", watch_count: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, ask_user_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing ask users"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, ask_user_path(conn, :new)
    assert html_response(conn, 200) =~ "New ask user"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, ask_user_path(conn, :create), ask_user: @valid_attrs
    assert redirected_to(conn) == ask_user_path(conn, :index)
    assert Repo.get_by(AskUser, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, ask_user_path(conn, :create), ask_user: @invalid_attrs
    assert html_response(conn, 200) =~ "New ask user"
  end

  test "shows chosen resource", %{conn: conn} do
    ask_user = Repo.insert! %AskUser{}
    conn = get conn, ask_user_path(conn, :show, ask_user)
    assert html_response(conn, 200) =~ "Show ask user"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, ask_user_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    ask_user = Repo.insert! %AskUser{}
    conn = get conn, ask_user_path(conn, :edit, ask_user)
    assert html_response(conn, 200) =~ "Edit ask user"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    ask_user = Repo.insert! %AskUser{}
    conn = put conn, ask_user_path(conn, :update, ask_user), ask_user: @valid_attrs
    assert redirected_to(conn) == ask_user_path(conn, :show, ask_user)
    assert Repo.get_by(AskUser, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    ask_user = Repo.insert! %AskUser{}
    conn = put conn, ask_user_path(conn, :update, ask_user), ask_user: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit ask user"
  end

  test "deletes chosen resource", %{conn: conn} do
    ask_user = Repo.insert! %AskUser{}
    conn = delete conn, ask_user_path(conn, :delete, ask_user)
    assert redirected_to(conn) == ask_user_path(conn, :index)
    refute Repo.get(AskUser, ask_user.id)
  end
end
