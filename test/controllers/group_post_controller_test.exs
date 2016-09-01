defmodule Zizhixi.GroupPostControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.GroupPost
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, group_post_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing group posts"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, group_post_path(conn, :new)
    assert html_response(conn, 200) =~ "New group post"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, group_post_path(conn, :create), group_post: @valid_attrs
    assert redirected_to(conn) == group_post_path(conn, :index)
    assert Repo.get_by(GroupPost, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, group_post_path(conn, :create), group_post: @invalid_attrs
    assert html_response(conn, 200) =~ "New group post"
  end

  test "shows chosen resource", %{conn: conn} do
    group_post = Repo.insert! %GroupPost{}
    conn = get conn, group_post_path(conn, :show, group_post)
    assert html_response(conn, 200) =~ "Show group post"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, group_post_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    group_post = Repo.insert! %GroupPost{}
    conn = get conn, group_post_path(conn, :edit, group_post)
    assert html_response(conn, 200) =~ "Edit group post"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    group_post = Repo.insert! %GroupPost{}
    conn = put conn, group_post_path(conn, :update, group_post), group_post: @valid_attrs
    assert redirected_to(conn) == group_post_path(conn, :show, group_post)
    assert Repo.get_by(GroupPost, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    group_post = Repo.insert! %GroupPost{}
    conn = put conn, group_post_path(conn, :update, group_post), group_post: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit group post"
  end

  test "deletes chosen resource", %{conn: conn} do
    group_post = Repo.insert! %GroupPost{}
    conn = delete conn, group_post_path(conn, :delete, group_post)
    assert redirected_to(conn) == group_post_path(conn, :index)
    refute Repo.get(GroupPost, group_post.id)
  end
end
