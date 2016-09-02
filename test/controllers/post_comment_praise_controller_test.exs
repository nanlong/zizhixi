defmodule Zizhixi.PostCommentPraiseControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.{PostComment, PostCommentPraise}
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = conn
    |> Zizhixi.PostCommentControllerTest.create
    |> get(post_comment_praise_path(conn, :index, Repo.one(PostComment)))

    assert html_response(conn, 200) =~ "<html"
  end

  test "creates resource and redirects when data", %{conn: conn} do
    conn = conn
    |> Zizhixi.PostCommentControllerTest.create
    |> post(post_comment_praise_path(conn, :create, Repo.one(PostComment)))

    assert redirected_to(conn) == post_path(conn, :show, Repo.one(PostComment).post_id)

    assert Repo.one(PostComment).praise_count == 1
  end

  test "deletes chosen resource", %{conn: conn} do
    conn = conn
    |> Zizhixi.PostCommentControllerTest.create
    |> post(post_comment_praise_path(conn, :create, Repo.one(PostComment)))
    |> delete(post_comment_praise_path(conn, :delete, Repo.one(PostComment), Repo.one(PostCommentPraise)))

    assert redirected_to(conn) == post_path(conn, :show, Repo.one(PostComment).post_id)
    assert Repo.one(PostComment).praise_count == 0
  end
end
