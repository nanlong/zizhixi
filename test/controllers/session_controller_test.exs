defmodule Zizhixi.SessionControllerTest do
  use Zizhixi.ConnCase

  # alias Zizhixi.User
  @valid_attrs %{
    account: "Test",
    password: "testpassword",
  }
  @invalid_attrs %{
    account: "",
    password: ""
  }

  # test "lists all entries on index", %{conn: conn} do
  #   conn = get conn, session_path(conn, :index)
  #   assert html_response(conn, 200) =~ "Listing users"
  # end
  #
  test "renders form for new resources", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert html_response(conn, 200) =~ "<html"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = conn
    |> Zizhixi.UserControllerTest.create
    |> post(session_path(conn, :create), user: @valid_attrs)

    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "<html"
  end

  # test "shows chosen resource", %{conn: conn} do
  #   session = Repo.insert! %Session{}
  #   conn = get conn, session_path(conn, :show, session)
  #   assert html_response(conn, 200) =~ "Show session"
  # end
  #
  # test "renders page not found when id is nonexistent", %{conn: conn} do
  #   assert_error_sent 404, fn ->
  #     get conn, session_path(conn, :show, "11111111-1111-1111-1111-111111111111")
  #   end
  # end
  #
  # test "renders form for editing chosen resource", %{conn: conn} do
  #   session = Repo.insert! %Session{}
  #   conn = get conn, session_path(conn, :edit, session)
  #   assert html_response(conn, 200) =~ "Edit session"
  # end
  #
  # test "updates chosen resource and redirects when data is valid", %{conn: conn} do
  #   session = Repo.insert! %Session{}
  #   conn = put conn, session_path(conn, :update, session), session: @valid_attrs
  #   assert redirected_to(conn) == session_path(conn, :show, session)
  #   assert Repo.get_by(Session, @valid_attrs)
  # end
  #
  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   session = Repo.insert! %Session{}
  #   conn = put conn, session_path(conn, :update, session), session: @invalid_attrs
  #   assert html_response(conn, 200) =~ "Edit session"
  # end
  #
  test "deletes chosen resource", %{conn: conn} do
    conn = conn
    |> create
    |> get(session_path(conn, :delete))

    assert redirected_to(conn) == page_path(conn, :index)
  end

  def create(conn) do
    conn
    |> Zizhixi.UserControllerTest.create
    |> post(session_path(conn, :create), user: @valid_attrs)
  end
end
