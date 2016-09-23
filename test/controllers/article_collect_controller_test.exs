defmodule Zizhixi.ArticleCollectControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.ArticleCollect
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, article_collect_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing article collects"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, article_collect_path(conn, :new)
    assert html_response(conn, 200) =~ "New article collect"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, article_collect_path(conn, :create), article_collect: @valid_attrs
    assert redirected_to(conn) == article_collect_path(conn, :index)
    assert Repo.get_by(ArticleCollect, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, article_collect_path(conn, :create), article_collect: @invalid_attrs
    assert html_response(conn, 200) =~ "New article collect"
  end

  test "shows chosen resource", %{conn: conn} do
    article_collect = Repo.insert! %ArticleCollect{}
    conn = get conn, article_collect_path(conn, :show, article_collect)
    assert html_response(conn, 200) =~ "Show article collect"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, article_collect_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    article_collect = Repo.insert! %ArticleCollect{}
    conn = get conn, article_collect_path(conn, :edit, article_collect)
    assert html_response(conn, 200) =~ "Edit article collect"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    article_collect = Repo.insert! %ArticleCollect{}
    conn = put conn, article_collect_path(conn, :update, article_collect), article_collect: @valid_attrs
    assert redirected_to(conn) == article_collect_path(conn, :show, article_collect)
    assert Repo.get_by(ArticleCollect, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    article_collect = Repo.insert! %ArticleCollect{}
    conn = put conn, article_collect_path(conn, :update, article_collect), article_collect: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit article collect"
  end

  test "deletes chosen resource", %{conn: conn} do
    article_collect = Repo.insert! %ArticleCollect{}
    conn = delete conn, article_collect_path(conn, :delete, article_collect)
    assert redirected_to(conn) == article_collect_path(conn, :index)
    refute Repo.get(ArticleCollect, article_collect.id)
  end
end
