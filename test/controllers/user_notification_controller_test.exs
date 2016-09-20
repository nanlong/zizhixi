defmodule Zizhixi.UserNotificationControllerTest do
  use Zizhixi.ConnCase

  alias Zizhixi.UserNotification
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_notification_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing notifications"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, user_notification_path(conn, :new)
    assert html_response(conn, 200) =~ "New user notification"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, user_notification_path(conn, :create), user_notification: @valid_attrs
    assert redirected_to(conn) == user_notification_path(conn, :index)
    assert Repo.get_by(UserNotification, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_notification_path(conn, :create), user_notification: @invalid_attrs
    assert html_response(conn, 200) =~ "New user notification"
  end

  test "shows chosen resource", %{conn: conn} do
    user_notification = Repo.insert! %UserNotification{}
    conn = get conn, user_notification_path(conn, :show, user_notification)
    assert html_response(conn, 200) =~ "Show user notification"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_notification_path(conn, :show, "11111111-1111-1111-1111-111111111111")
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    user_notification = Repo.insert! %UserNotification{}
    conn = get conn, user_notification_path(conn, :edit, user_notification)
    assert html_response(conn, 200) =~ "Edit user notification"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    user_notification = Repo.insert! %UserNotification{}
    conn = put conn, user_notification_path(conn, :update, user_notification), user_notification: @valid_attrs
    assert redirected_to(conn) == user_notification_path(conn, :show, user_notification)
    assert Repo.get_by(UserNotification, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user_notification = Repo.insert! %UserNotification{}
    conn = put conn, user_notification_path(conn, :update, user_notification), user_notification: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit user notification"
  end

  test "deletes chosen resource", %{conn: conn} do
    user_notification = Repo.insert! %UserNotification{}
    conn = delete conn, user_notification_path(conn, :delete, user_notification)
    assert redirected_to(conn) == user_notification_path(conn, :index)
    refute Repo.get(UserNotification, user_notification.id)
  end
end
