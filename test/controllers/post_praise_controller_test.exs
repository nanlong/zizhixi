defmodule Zizhixi.PostPraiseControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.PostPraise
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_praise_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    post_praise = Repo.insert! %PostPraise{}
    conn = get conn, post_praise_path(conn, :show, post_praise)
    assert json_response(conn, 200)["data"] == %{"id" => post_praise.id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, post_praise_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, post_praise_path(conn, :create), post_praise: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(PostPraise, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, post_praise_path(conn, :create), post_praise: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    post_praise = Repo.insert! %PostPraise{}
    conn = put conn, post_praise_path(conn, :update, post_praise), post_praise: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(PostPraise, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    post_praise = Repo.insert! %PostPraise{}
    conn = put conn, post_praise_path(conn, :update, post_praise), post_praise: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    post_praise = Repo.insert! %PostPraise{}
    conn = delete conn, post_praise_path(conn, :delete, post_praise)
    assert response(conn, 204)
    refute Repo.get(PostPraise, post_praise.id)
  end
end
