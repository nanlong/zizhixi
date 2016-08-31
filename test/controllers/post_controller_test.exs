defmodule Zizhixi.PostControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.{Post, User}

  @valid_attrs %{
    title: "some content",
    content: "some content"
  }

  @invalid_attrs %{
    title: "",
    content: ""
  }

  @user_valid_attrs %{
    username: "Test",
    email: "test@zizhixi.com",
    password: "testpassword",
  }

  @user_signin_atts %{
    account: "Test",
    password: "testpassword"
  }

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_path(conn, :index)
    assert html_response(conn, 200) =~ "<html"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = post conn, account_path(conn, :signup), user: @user_valid_attrs
    conn = get conn, post_path(conn, :new)
    assert html_response(conn, 200) =~ "<html"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, account_path(conn, :signup), user: @user_valid_attrs
    conn = post conn, post_path(conn, :create), post: @valid_attrs
    assert redirected_to(conn) == post_path(conn, :index)
    assert Repo.get_by(Post, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, account_path(conn, :signup), user: @user_valid_attrs
    conn = post conn, post_path(conn, :create), post: @invalid_attrs
    assert html_response(conn, 200) =~ "can&#39;t be blank"
  end

  test "shows chosen resource", %{conn: conn} do
    post = insert_post

    conn = get conn, post_path(conn, :show, post)
    assert html_response(conn, 200) =~ "<html"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, post_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    post = insert_post
    conn = post conn, account_path(conn, :signin), user: @user_signin_atts
    conn = get conn, post_path(conn, :edit, post)
    assert html_response(conn, 200) =~ "<html"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    post = insert_post
    post_params = %{title: "edit title", content: "edit content"}
    conn = post conn, account_path(conn, :signin), user: @user_signin_atts
    conn = put conn, post_path(conn, :update, post), post: post_params
    assert redirected_to(conn) == post_path(conn, :show, post)
    assert Repo.get_by(Post, post_params)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    post = insert_post
    conn = post conn, account_path(conn, :signin), user: @user_signin_atts
    conn = put conn, post_path(conn, :update, post), post: @invalid_attrs
    assert html_response(conn, 200) =~ "<html"
  end

  test "deletes chosen resource", %{conn: conn} do
    post = insert_post
    conn = post conn, account_path(conn, :signin), user: @user_signin_atts
    conn = delete conn, post_path(conn, :delete, post)
    assert redirected_to(conn) == post_path(conn, :index)
    post = Repo.get(Post, post.id)
    assert post.is_deleted
  end

  defp insert_post() do
    changeset = User.changeset(:signup, %User{},  @user_valid_attrs)
    {:ok, user} = Repo.insert(changeset)

    Repo.insert! %Post{
      title: "some content",
      content: "some content",
      user_id: user.id
    }
  end
end
