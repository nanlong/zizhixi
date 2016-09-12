defmodule Zizhixi.MarketControllerTest do
  use Zizhixi.ConnCase

  # alias Zizhixi.Market
  # @valid_attrs %{}
  # @invalid_attrs %{}
  #
  # test "lists all entries on index", %{conn: conn} do
  #   conn = get conn, market_path(conn, :index)
  #   assert html_response(conn, 200) =~ "Listing markets"
  # end
  #
  # test "renders form for new resources", %{conn: conn} do
  #   conn = get conn, market_path(conn, :new)
  #   assert html_response(conn, 200) =~ "New market"
  # end
  #
  # test "creates resource and redirects when data is valid", %{conn: conn} do
  #   conn = post conn, market_path(conn, :create), market: @valid_attrs
  #   assert redirected_to(conn) == market_path(conn, :index)
  #   assert Repo.get_by(Market, @valid_attrs)
  # end
  #
  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, market_path(conn, :create), market: @invalid_attrs
  #   assert html_response(conn, 200) =~ "New market"
  # end
  #
  # test "shows chosen resource", %{conn: conn} do
  #   market = Repo.insert! %Market{}
  #   conn = get conn, market_path(conn, :show, market)
  #   assert html_response(conn, 200) =~ "Show market"
  # end
  #
  # test "renders page not found when id is nonexistent", %{conn: conn} do
  #   assert_error_sent 404, fn ->
  #     get conn, market_path(conn, :show, "11111111-1111-1111-1111-111111111111")
  #   end
  # end
  #
  # test "renders form for editing chosen resource", %{conn: conn} do
  #   market = Repo.insert! %Market{}
  #   conn = get conn, market_path(conn, :edit, market)
  #   assert html_response(conn, 200) =~ "Edit market"
  # end
  #
  # test "updates chosen resource and redirects when data is valid", %{conn: conn} do
  #   market = Repo.insert! %Market{}
  #   conn = put conn, market_path(conn, :update, market), market: @valid_attrs
  #   assert redirected_to(conn) == market_path(conn, :show, market)
  #   assert Repo.get_by(Market, @valid_attrs)
  # end
  #
  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   market = Repo.insert! %Market{}
  #   conn = put conn, market_path(conn, :update, market), market: @invalid_attrs
  #   assert html_response(conn, 200) =~ "Edit market"
  # end
  #
  # test "deletes chosen resource", %{conn: conn} do
  #   market = Repo.insert! %Market{}
  #   conn = delete conn, market_path(conn, :delete, market)
  #   assert redirected_to(conn) == market_path(conn, :index)
  #   refute Repo.get(Market, market.id)
  # end
end
