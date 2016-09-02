defmodule Zizhixi.GroupControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.Group
  @valid_attrs %{
    name: "some content",
    logo: "some content",
    description: "some content"
  }
  @invalid_attrs %{
    name: "",
    logo: "",
    description: ""
  }

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, group_path(conn, :index)
    assert html_response(conn, 200) =~ "<html"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = conn
    |> Zizhixi.UserControllerTest.create
    |> get(group_path(conn, :new))

    assert html_response(conn, 200) =~ "<html"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = conn |> create

    assert redirected_to(conn) == group_path(conn, :index)
    assert Repo.get_by(Group, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = conn
    |> Zizhixi.UserControllerTest.create
    |> post(group_path(conn, :create), group: @invalid_attrs)

    assert html_response(conn, 200) =~ "<html"
  end

  test "shows chosen resource", %{conn: conn} do
    {:ok, group} = Zizhixi.GroupTest.insert
    conn = get conn, group_path(conn, :show, group)
    assert html_response(conn, 200) =~ "<html"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, group_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    conn = conn
    |> create
    |> get(group_path(conn, :edit, Repo.one(Group)))

    assert html_response(conn, 200) =~ "<html"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    conn = conn
    |> create
    |> put(group_path(conn, :update, Repo.one(Group)), group: @valid_attrs)

    assert redirected_to(conn) == group_path(conn, :show, Repo.one(Group))
    assert Repo.get_by(Group, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    conn = conn
    |> create
    |> put(group_path(conn, :update, Repo.one(Group)), group: @invalid_attrs)

    assert html_response(conn, 200) =~ "<html"
  end

  test "deletes chosen resource", %{conn: conn} do
    conn = conn
    |> create
    |> delete(group_path(conn, :delete, Repo.one(Group)))

    assert redirected_to(conn) == group_path(conn, :index)
    refute Repo.get_by(Group, @valid_attrs)
  end

  def create(conn) do
    conn
    |> Zizhixi.UserControllerTest.create
    |> post(group_path(conn, :create), group: @valid_attrs)
  end
end
