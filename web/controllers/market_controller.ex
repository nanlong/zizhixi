defmodule Zizhixi.MarketController do
  use Zizhixi.Web, :controller

  # alias Zizhixi.Market

  def index(conn, _params) do
    render(conn, "index.html")
  end

  # def new(conn, _params) do
  #   changeset = Market.changeset(%Market{})
  #   render(conn, "new.html", changeset: changeset)
  # end
  #
  # def create(conn, %{"market" => market_params}) do
  #   changeset = Market.changeset(%Market{}, market_params)
  #
  #   case Repo.insert(changeset) do
  #     {:ok, _market} ->
  #       conn
  #       |> put_flash(:info, "Market created successfully.")
  #       |> redirect(to: market_path(conn, :index))
  #     {:error, changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end
  #
  # def show(conn, %{"id" => id}) do
  #   market = Repo.get!(Market, id)
  #   render(conn, "show.html", market: market)
  # end
  #
  # def edit(conn, %{"id" => id}) do
  #   market = Repo.get!(Market, id)
  #   changeset = Market.changeset(market)
  #   render(conn, "edit.html", market: market, changeset: changeset)
  # end
  #
  # def update(conn, %{"id" => id, "market" => market_params}) do
  #   market = Repo.get!(Market, id)
  #   changeset = Market.changeset(market, market_params)
  #
  #   case Repo.update(changeset) do
  #     {:ok, market} ->
  #       conn
  #       |> put_flash(:info, "Market updated successfully.")
  #       |> redirect(to: market_path(conn, :show, market))
  #     {:error, changeset} ->
  #       render(conn, "edit.html", market: market, changeset: changeset)
  #   end
  # end
  #
  # def delete(conn, %{"id" => id}) do
  #   market = Repo.get!(Market, id)
  #
  #   # Here we use delete! (with a bang) because we expect
  #   # it to always work (and if it does not, it will raise).
  #   Repo.delete!(market)
  #
  #   conn
  #   |> put_flash(:info, "Market deleted successfully.")
  #   |> redirect(to: market_path(conn, :index))
  # end
end
