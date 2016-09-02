defmodule Zizhixi.PostControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.{Post}

  @valid_attrs %{
    title: "some content",
    content: "some content"
  }

  @invalid_attrs %{
    title: "",
    content: ""
  }

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_path(conn, :index)
    assert html_response(conn, 200) =~ "<html"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = conn
    |> Zizhixi.UserControllerTest.create
    |> get(post_path(conn, :new))

    assert html_response(conn, 200) =~ "<html"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = conn
    |> Zizhixi.UserControllerTest.create
    |> post(post_path(conn, :create), post: @valid_attrs)

    assert redirected_to(conn) == post_path(conn, :index)
    assert Repo.get_by(Post, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = conn
    |> Zizhixi.UserControllerTest.create
    |> post(post_path(conn, :create), post: @invalid_attrs)

    assert html_response(conn, 200) =~ "can&#39;t be blank"
  end

  test "shows chosen resource", %{conn: conn} do
    conn = conn
    |> create
    |> get(post_path(conn, :show, Repo.one(Post)))

    assert html_response(conn, 200) =~ "<html"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, post_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    conn = conn
    |> create
    |> get(post_path(conn, :edit, Repo.one(Post)))

    assert html_response(conn, 200) =~ "<html"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    post_params = %{title: "edit title", content: "edit content"}

    conn = conn
    |> create
    |> put(post_path(conn, :update, Repo.one(Post)), post: post_params)

    assert redirected_to(conn) == post_path(conn, :show, Repo.one(Post))
    assert Repo.get_by(Post, post_params)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    conn = conn
    |> create
    |> put(post_path(conn, :update, Repo.one(Post)), post: @invalid_attrs)

    assert html_response(conn, 200) =~ "<html"
  end

  test "deletes chosen resource", %{conn: conn} do
    conn = conn
    |> create
    |> delete(post_path(conn, :delete, Repo.one(Post)))

    assert redirected_to(conn) == post_path(conn, :index)
    post = Repo.one(Post)
    assert post.is_deleted
  end

  # test "praise", %{conn: conn} do
  #   conn = conn
  #   |> create
  #   |> post(post_praise_path(conn, :create, Repo.one(Post)))
  #
  #   assert json_response(conn, 201) |> Map.has_key?("data")
  #
  #   post = Post |> Repo.one
  #   assert post.praise_count == 1
  # end

  def create(conn) do
    conn
    |> Zizhixi.UserControllerTest.create
    |> post(post_path(conn, :create), post: @valid_attrs)
  end
end
