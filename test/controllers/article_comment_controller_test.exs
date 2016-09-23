defmodule Zizhixi.ArticleCommentControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.ArticleComment
  @valid_attrs %{content: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, article_comment_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing article comments"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, article_comment_path(conn, :new)
    assert html_response(conn, 200) =~ "New article comment"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, article_comment_path(conn, :create), article_comment: @valid_attrs
    assert redirected_to(conn) == article_comment_path(conn, :index)
    assert Repo.get_by(ArticleComment, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, article_comment_path(conn, :create), article_comment: @invalid_attrs
    assert html_response(conn, 200) =~ "New article comment"
  end

  test "shows chosen resource", %{conn: conn} do
    article_comment = Repo.insert! %ArticleComment{}
    conn = get conn, article_comment_path(conn, :show, article_comment)
    assert html_response(conn, 200) =~ "Show article comment"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, article_comment_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    article_comment = Repo.insert! %ArticleComment{}
    conn = get conn, article_comment_path(conn, :edit, article_comment)
    assert html_response(conn, 200) =~ "Edit article comment"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    article_comment = Repo.insert! %ArticleComment{}
    conn = put conn, article_comment_path(conn, :update, article_comment), article_comment: @valid_attrs
    assert redirected_to(conn) == article_comment_path(conn, :show, article_comment)
    assert Repo.get_by(ArticleComment, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    article_comment = Repo.insert! %ArticleComment{}
    conn = put conn, article_comment_path(conn, :update, article_comment), article_comment: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit article comment"
  end

  test "deletes chosen resource", %{conn: conn} do
    article_comment = Repo.insert! %ArticleComment{}
    conn = delete conn, article_comment_path(conn, :delete, article_comment)
    assert redirected_to(conn) == article_comment_path(conn, :index)
    refute Repo.get(ArticleComment, article_comment.id)
  end
end
