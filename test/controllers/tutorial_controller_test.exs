defmodule Zizhixi.TutorialControllerTest do
  use Zizhixi.ConnCase

  # alias Zizhixi.Tutorial
  # @valid_attrs %{}
  # @invalid_attrs %{}
  #
  # test "lists all entries on index", %{conn: conn} do
  #   conn = get conn, tutorial_path(conn, :index)
  #   assert html_response(conn, 200) =~ "Listing tutorials"
  # end
  #
  # test "renders form for new resources", %{conn: conn} do
  #   conn = get conn, tutorial_path(conn, :new)
  #   assert html_response(conn, 200) =~ "New tutorial"
  # end
  #
  # test "creates resource and redirects when data is valid", %{conn: conn} do
  #   conn = post conn, tutorial_path(conn, :create), tutorial: @valid_attrs
  #   assert redirected_to(conn) == tutorial_path(conn, :index)
  #   assert Repo.get_by(Tutorial, @valid_attrs)
  # end
  #
  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, tutorial_path(conn, :create), tutorial: @invalid_attrs
  #   assert html_response(conn, 200) =~ "New tutorial"
  # end
  #
  # test "shows chosen resource", %{conn: conn} do
  #   tutorial = Repo.insert! %Tutorial{}
  #   conn = get conn, tutorial_path(conn, :show, tutorial)
  #   assert html_response(conn, 200) =~ "Show tutorial"
  # end
  #
  # test "renders page not found when id is nonexistent", %{conn: conn} do
  #   assert_error_sent 404, fn ->
  #     get conn, tutorial_path(conn, :show, "11111111-1111-1111-1111-111111111111")
  #   end
  # end
  #
  # test "renders form for editing chosen resource", %{conn: conn} do
  #   tutorial = Repo.insert! %Tutorial{}
  #   conn = get conn, tutorial_path(conn, :edit, tutorial)
  #   assert html_response(conn, 200) =~ "Edit tutorial"
  # end
  #
  # test "updates chosen resource and redirects when data is valid", %{conn: conn} do
  #   tutorial = Repo.insert! %Tutorial{}
  #   conn = put conn, tutorial_path(conn, :update, tutorial), tutorial: @valid_attrs
  #   assert redirected_to(conn) == tutorial_path(conn, :show, tutorial)
  #   assert Repo.get_by(Tutorial, @valid_attrs)
  # end
  #
  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   tutorial = Repo.insert! %Tutorial{}
  #   conn = put conn, tutorial_path(conn, :update, tutorial), tutorial: @invalid_attrs
  #   assert html_response(conn, 200) =~ "Edit tutorial"
  # end
  #
  # test "deletes chosen resource", %{conn: conn} do
  #   tutorial = Repo.insert! %Tutorial{}
  #   conn = delete conn, tutorial_path(conn, :delete, tutorial)
  #   assert redirected_to(conn) == tutorial_path(conn, :index)
  #   refute Repo.get(Tutorial, tutorial.id)
  # end
end
