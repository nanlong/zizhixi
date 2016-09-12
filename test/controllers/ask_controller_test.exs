defmodule Zizhixi.AskControllerTest do
  use Zizhixi.ConnCase

  # alias Zizhixi.Ask
  # @valid_attrs %{}
  # @invalid_attrs %{}
  #
  # test "lists all entries on index", %{conn: conn} do
  #   conn = get conn, ask_path(conn, :index)
  #   assert html_response(conn, 200) =~ "Listing asks"
  # end
  #
  # test "renders form for new resources", %{conn: conn} do
  #   conn = get conn, ask_path(conn, :new)
  #   assert html_response(conn, 200) =~ "New ask"
  # end
  #
  # test "creates resource and redirects when data is valid", %{conn: conn} do
  #   conn = post conn, ask_path(conn, :create), ask: @valid_attrs
  #   assert redirected_to(conn) == ask_path(conn, :index)
  #   assert Repo.get_by(Ask, @valid_attrs)
  # end
  #
  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, ask_path(conn, :create), ask: @invalid_attrs
  #   assert html_response(conn, 200) =~ "New ask"
  # end
  #
  # test "shows chosen resource", %{conn: conn} do
  #   ask = Repo.insert! %Ask{}
  #   conn = get conn, ask_path(conn, :show, ask)
  #   assert html_response(conn, 200) =~ "Show ask"
  # end
  #
  # test "renders page not found when id is nonexistent", %{conn: conn} do
  #   assert_error_sent 404, fn ->
  #     get conn, ask_path(conn, :show, "11111111-1111-1111-1111-111111111111")
  #   end
  # end
  #
  # test "renders form for editing chosen resource", %{conn: conn} do
  #   ask = Repo.insert! %Ask{}
  #   conn = get conn, ask_path(conn, :edit, ask)
  #   assert html_response(conn, 200) =~ "Edit ask"
  # end
  #
  # test "updates chosen resource and redirects when data is valid", %{conn: conn} do
  #   ask = Repo.insert! %Ask{}
  #   conn = put conn, ask_path(conn, :update, ask), ask: @valid_attrs
  #   assert redirected_to(conn) == ask_path(conn, :show, ask)
  #   assert Repo.get_by(Ask, @valid_attrs)
  # end
  #
  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   ask = Repo.insert! %Ask{}
  #   conn = put conn, ask_path(conn, :update, ask), ask: @invalid_attrs
  #   assert html_response(conn, 200) =~ "Edit ask"
  # end
  #
  # test "deletes chosen resource", %{conn: conn} do
  #   ask = Repo.insert! %Ask{}
  #   conn = delete conn, ask_path(conn, :delete, ask)
  #   assert redirected_to(conn) == ask_path(conn, :index)
  #   refute Repo.get(Ask, ask.id)
  # end
end
