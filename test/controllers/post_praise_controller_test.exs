defmodule Zizhixi.PostPraiseControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.{Post, PostPraise}

  test "index", %{conn: conn} do
    conn = conn
    |> Zizhixi.PostControllerTest.create
    |> get(post_praise_path(conn, :index, Repo.one(Post)))
    assert html_response(conn, 200) =~ "<html"
  end

  test "create", %{conn: conn} do
    conn
    |> Zizhixi.PostControllerTest.create
    |> post(post_praise_path(conn, :create, Repo.one(Post)))

    assert Repo.one(Post).praise_count == 1
    assert Repo.one(PostPraise)
  end

  test "delete", %{conn: conn} do
    conn
    |> Zizhixi.PostControllerTest.create
    |> post(post_praise_path(conn, :create, Repo.one(Post)))
    |> delete(post_praise_path(conn, :delete, Repo.one(Post), Repo.one(PostPraise)))

    assert Repo.one(Post).praise_count == 0
    refute Repo.one(PostPraise)
  end
end
