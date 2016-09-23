defmodule Zizhixi.ArticlePraiseControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.ArticlePraise
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, article_praise_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing article praises"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, article_praise_path(conn, :new)
    assert html_response(conn, 200) =~ "New article praise"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, article_praise_path(conn, :create), article_praise: @valid_attrs
    assert redirected_to(conn) == article_praise_path(conn, :index)
    assert Repo.get_by(ArticlePraise, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, article_praise_path(conn, :create), article_praise: @invalid_attrs
    assert html_response(conn, 200) =~ "New article praise"
  end

  test "shows chosen resource", %{conn: conn} do
    article_praise = Repo.insert! %ArticlePraise{}
    conn = get conn, article_praise_path(conn, :show, article_praise)
    assert html_response(conn, 200) =~ "Show article praise"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, article_praise_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    article_praise = Repo.insert! %ArticlePraise{}
    conn = get conn, article_praise_path(conn, :edit, article_praise)
    assert html_response(conn, 200) =~ "Edit article praise"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    article_praise = Repo.insert! %ArticlePraise{}
    conn = put conn, article_praise_path(conn, :update, article_praise), article_praise: @valid_attrs
    assert redirected_to(conn) == article_praise_path(conn, :show, article_praise)
    assert Repo.get_by(ArticlePraise, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    article_praise = Repo.insert! %ArticlePraise{}
    conn = put conn, article_praise_path(conn, :update, article_praise), article_praise: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit article praise"
  end

  test "deletes chosen resource", %{conn: conn} do
    article_praise = Repo.insert! %ArticlePraise{}
    conn = delete conn, article_praise_path(conn, :delete, article_praise)
    assert redirected_to(conn) == article_praise_path(conn, :index)
    refute Repo.get(ArticlePraise, article_praise.id)
  end
end
