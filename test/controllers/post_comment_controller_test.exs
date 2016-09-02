defmodule Zizhixi.PostCommentControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.Post
  alias Zizhixi.PostComment

  @valid_attrs %{content: "some content"}
  @invalid_attrs %{content: ""}

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = conn
    |> Zizhixi.PostControllerTest.create
    |> post(post_comment_path(conn, :create, Repo.one(Post)), post_comment: @valid_attrs)

    assert json_response(conn, 200) |> Map.has_key?("data")
    assert Repo.get_by(PostComment, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = conn
    |> Zizhixi.PostControllerTest.create
    |> post(post_comment_path(conn, :create, Post |> Repo.one), post_comment: @invalid_attrs)

    refute json_response(conn, 400) |> Map.has_key?("error")
  end

  test "shows chosen resource", %{conn: conn} do
    conn = conn
    |> create
    |> get(post_comment_path(conn, :show, Repo.one(Post), Repo.one(PostComment)))

    assert html_response(conn, 200) =~ "Show post comment"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, post_comment_path(conn, :show, "11111111-1111-1111-1111-111111111111", "11111111-1111-1111-1111-111111111111")
    end
  end

  test "deletes chosen resource", %{conn: conn} do
    conn = conn
    |> create
    |> delete(post_comment_path(conn, :delete, Repo.one(PostComment)))

    assert json_response(conn, 204)
    refute PostComment |> Repo.get_by(%{id: Repo.one(PostComment).id, is_deleted: false})
  end

  # test "praise", %{conn: conn} do
  #   conn = conn
  #   |> create
  #   |> post(post_comment_praise_path(conn, :praise, Repo.one(PostComment)))
  #
  #   assert json_response(conn, 200) |> Map.get("status") == 1
  #
  #   assert Repo.one(PostComment).praise_count == 1
  # end

  def create(conn) do
    conn
    |> Zizhixi.PostControllerTest.create
    |> post(post_comment_path(conn, :create, Post |> Repo.one), post_comment: @valid_attrs)
  end
end
