defmodule Zizhixi.PostCommentControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.Post
  alias Zizhixi.PostComment

  @valid_attrs %{content: "some content"}
  @invalid_attrs %{content: ""}

  defp signup(conn) do
    user_params = %{
      username: "Test",
      email: "test@zizhixi.com",
      password: "testpassword",
    }
    post conn, account_path(conn, :signup), user: user_params
  end

  defp signin(conn) do
    user_params = %{
      account: "Test",
      password: "testpassword"
    }
    post conn, account_path(conn, :signin), user: user_params
  end

  defp create_post(conn) do
    post_params = %{
      title: "some content",
      content: "some content"
    }
    post conn, post_path(conn, :create), post: post_params
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = conn
    |> signup
    |> create_post
    |> post(post_comment_path(conn, :create, Post |> Repo.one), post_comment: @valid_attrs)

    assert json_response(conn, 200) |> Map.has_key?("data")
    assert Repo.get_by(PostComment, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = conn
    |> signup
    |> create_post
    |> post(post_comment_path(conn, :create, Post |> Repo.one), post_comment: @invalid_attrs)

    refute json_response(conn, 400) |> Map.has_key?("error")
  end

  test "shows chosen resource", %{conn: conn} do
    {:ok, post_comment} = Zizhixi.PostCommentTest.insert_comment
    conn = get conn, post_comment_path(conn, :show, post_comment.post_id, post_comment)
    assert html_response(conn, 200) =~ "Show post comment"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, post_comment_path(conn, :show, "11111111-1111-1111-1111-111111111111", "11111111-1111-1111-1111-111111111111")
    end
  end

  test "deletes chosen resource", %{conn: conn} do
    {:ok, post_comment} = Zizhixi.PostCommentTest.insert_comment

    conn = conn
    |> signin
    |> delete(post_comment_path(conn, :delete, post_comment.post_id, post_comment))

    assert json_response(conn, 204)
    refute PostComment |> Repo.get_by(%{id: post_comment.id, is_deleted: false})
  end
end
