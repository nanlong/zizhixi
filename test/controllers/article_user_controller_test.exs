defmodule Zizhixi.ArticleUserControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.ArticleUser
  @valid_attrs %{article_count: 42, collect_count: 42, comment_count: 42, praise_count: 42}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, article_user_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing article users"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, article_user_path(conn, :new)
    assert html_response(conn, 200) =~ "New article user"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, article_user_path(conn, :create), article_user: @valid_attrs
    assert redirected_to(conn) == article_user_path(conn, :index)
    assert Repo.get_by(ArticleUser, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, article_user_path(conn, :create), article_user: @invalid_attrs
    assert html_response(conn, 200) =~ "New article user"
  end

  test "shows chosen resource", %{conn: conn} do
    article_user = Repo.insert! %ArticleUser{}
    conn = get conn, article_user_path(conn, :show, article_user)
    assert html_response(conn, 200) =~ "Show article user"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, article_user_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    article_user = Repo.insert! %ArticleUser{}
    conn = get conn, article_user_path(conn, :edit, article_user)
    assert html_response(conn, 200) =~ "Edit article user"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    article_user = Repo.insert! %ArticleUser{}
    conn = put conn, article_user_path(conn, :update, article_user), article_user: @valid_attrs
    assert redirected_to(conn) == article_user_path(conn, :show, article_user)
    assert Repo.get_by(ArticleUser, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    article_user = Repo.insert! %ArticleUser{}
    conn = put conn, article_user_path(conn, :update, article_user), article_user: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit article user"
  end

  test "deletes chosen resource", %{conn: conn} do
    article_user = Repo.insert! %ArticleUser{}
    conn = delete conn, article_user_path(conn, :delete, article_user)
    assert redirected_to(conn) == article_user_path(conn, :index)
    refute Repo.get(ArticleUser, article_user.id)
  end
end
