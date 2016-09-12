defmodule Zizhixi.AskController do
  use Zizhixi.Web, :controller

  # alias Zizhixi.Ask

  def index(conn, _params) do

    render(conn, "index.html")
  end

  # def new(conn, _params) do
  #   changeset = Ask.changeset(%Ask{})
  #   render(conn, "new.html", changeset: changeset)
  # end
  #
  # def create(conn, %{"ask" => ask_params}) do
  #   changeset = Ask.changeset(%Ask{}, ask_params)
  #
  #   case Repo.insert(changeset) do
  #     {:ok, _ask} ->
  #       conn
  #       |> put_flash(:info, "Ask created successfully.")
  #       |> redirect(to: ask_path(conn, :index))
  #     {:error, changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end
  #
  # def show(conn, %{"id" => id}) do
  #   ask = Repo.get!(Ask, id)
  #   render(conn, "show.html", ask: ask)
  # end
  #
  # def edit(conn, %{"id" => id}) do
  #   ask = Repo.get!(Ask, id)
  #   changeset = Ask.changeset(ask)
  #   render(conn, "edit.html", ask: ask, changeset: changeset)
  # end
  #
  # def update(conn, %{"id" => id, "ask" => ask_params}) do
  #   ask = Repo.get!(Ask, id)
  #   changeset = Ask.changeset(ask, ask_params)
  #
  #   case Repo.update(changeset) do
  #     {:ok, ask} ->
  #       conn
  #       |> put_flash(:info, "Ask updated successfully.")
  #       |> redirect(to: ask_path(conn, :show, ask))
  #     {:error, changeset} ->
  #       render(conn, "edit.html", ask: ask, changeset: changeset)
  #   end
  # end
  #
  # def delete(conn, %{"id" => id}) do
  #   ask = Repo.get!(Ask, id)
  #
  #   # Here we use delete! (with a bang) because we expect
  #   # it to always work (and if it does not, it will raise).
  #   Repo.delete!(ask)
  #
  #   conn
  #   |> put_flash(:info, "Ask deleted successfully.")
  #   |> redirect(to: ask_path(conn, :index))
  # end
end
