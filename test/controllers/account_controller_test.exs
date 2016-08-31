defmodule Zizhixi.AccountControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.User

  @signup_valid_attrs %{
    username: "Test",
    email: "test@zizhixi.com",
    password: "testpassword",
  }

  @signin_email_valid_attrs %{
    account: "test@zizhixi.com",
    password: "testpassword",
  }

  @signin_username_valid_attrs %{
    account: "Test",
    password: "testpassword",
  }

  @invalid_attrs %{
    username: "",
    email: "",
    password: ""
  }

  test "get signup page", %{conn: conn} do
    conn = get conn, account_path(conn, :signup_page)
    assert html_response(conn, 200) =~ "用户注册"
  end

  test "post signup success", %{conn: conn} do
    conn = post conn, account_path(conn, :signup), user: @signup_valid_attrs
    assert conn.status == 302
    assert User |> Repo.get_by(@signup_valid_attrs |> Map.delete(:password))
  end

  test "post signup error", %{conn: conn} do
    conn = post conn, account_path(conn, :signup), user: @invalid_attrs
    assert html_response(conn, 200) =~ "can&#39;t be blank"
  end

  test "get signin page", %{conn: conn} do
    conn = get conn, account_path(conn, :signin_page)
    assert html_response(conn, 200) =~ "用户登录"
  end

  test "post signin success", %{conn: conn} do
    post conn, account_path(conn, :signup), user: @signup_valid_attrs

    conn = post conn, account_path(conn, :signin), user: @signin_username_valid_attrs
    assert conn.status == 302

    conn = post conn, account_path(conn, :signin), user: @signin_email_valid_attrs
    assert conn.status == 302
  end

  test "post signin error", %{conn: conn} do
    conn = post conn, account_path(conn, :signin), user: @invalid_attrs
    assert html_response(conn, 200) =~ "can&#39;t be blank"
  end

  test "signout", %{conn: conn} do
    conn = get conn, account_path(conn, :signout)
    assert conn.status == 302
  end

  def signup(conn) do
    post conn, account_path(conn, :signup), user: @signup_valid_attrs
  end

  def signin(conn) do
    post conn, account_path(conn, :signin), user: @signin_username_valid_attrs
  end
end
