defmodule Zizhixi.LinkCategoryControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.LinkCategory
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, link_category_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing link categories"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, link_category_path(conn, :new)
    assert html_response(conn, 200) =~ "New link category"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, link_category_path(conn, :create), link_category: @valid_attrs
    assert redirected_to(conn) == link_category_path(conn, :index)
    assert Repo.get_by(LinkCategory, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, link_category_path(conn, :create), link_category: @invalid_attrs
    assert html_response(conn, 200) =~ "New link category"
  end

  test "shows chosen resource", %{conn: conn} do
    link_category = Repo.insert! %LinkCategory{}
    conn = get conn, link_category_path(conn, :show, link_category)
    assert html_response(conn, 200) =~ "Show link category"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, link_category_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    link_category = Repo.insert! %LinkCategory{}
    conn = get conn, link_category_path(conn, :edit, link_category)
    assert html_response(conn, 200) =~ "Edit link category"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    link_category = Repo.insert! %LinkCategory{}
    conn = put conn, link_category_path(conn, :update, link_category), link_category: @valid_attrs
    assert redirected_to(conn) == link_category_path(conn, :show, link_category)
    assert Repo.get_by(LinkCategory, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    link_category = Repo.insert! %LinkCategory{}
    conn = put conn, link_category_path(conn, :update, link_category), link_category: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit link category"
  end

  test "deletes chosen resource", %{conn: conn} do
    link_category = Repo.insert! %LinkCategory{}
    conn = delete conn, link_category_path(conn, :delete, link_category)
    assert redirected_to(conn) == link_category_path(conn, :index)
    refute Repo.get(LinkCategory, link_category.id)
  end
end
