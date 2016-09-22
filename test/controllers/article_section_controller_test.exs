defmodule Zizhixi.ArticleSectionControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.ArticleSection
  @valid_attrs %{content: "some content", title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, article_section_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing article sections"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, article_section_path(conn, :new)
    assert html_response(conn, 200) =~ "New article section"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, article_section_path(conn, :create), article_section: @valid_attrs
    assert redirected_to(conn) == article_section_path(conn, :index)
    assert Repo.get_by(ArticleSection, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, article_section_path(conn, :create), article_section: @invalid_attrs
    assert html_response(conn, 200) =~ "New article section"
  end

  test "shows chosen resource", %{conn: conn} do
    article_section = Repo.insert! %ArticleSection{}
    conn = get conn, article_section_path(conn, :show, article_section)
    assert html_response(conn, 200) =~ "Show article section"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, article_section_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    article_section = Repo.insert! %ArticleSection{}
    conn = get conn, article_section_path(conn, :edit, article_section)
    assert html_response(conn, 200) =~ "Edit article section"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    article_section = Repo.insert! %ArticleSection{}
    conn = put conn, article_section_path(conn, :update, article_section), article_section: @valid_attrs
    assert redirected_to(conn) == article_section_path(conn, :show, article_section)
    assert Repo.get_by(ArticleSection, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    article_section = Repo.insert! %ArticleSection{}
    conn = put conn, article_section_path(conn, :update, article_section), article_section: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit article section"
  end

  test "deletes chosen resource", %{conn: conn} do
    article_section = Repo.insert! %ArticleSection{}
    conn = delete conn, article_section_path(conn, :delete, article_section)
    assert redirected_to(conn) == article_section_path(conn, :index)
    refute Repo.get(ArticleSection, article_section.id)
  end
end
