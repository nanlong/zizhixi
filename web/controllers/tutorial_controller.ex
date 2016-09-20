defmodule Zizhixi.TutorialController do
  use Zizhixi.Web, :controller

  # alias Zizhixi.Tutorial

  def index(conn, _params) do
    conn
    |> assign(:title, "天工")
    |> render("index.html")
  end

  # def new(conn, _params) do
  #   changeset = Tutorial.changeset(%Tutorial{})
  #   render(conn, "new.html", changeset: changeset)
  # end
  #
  # def create(conn, %{"tutorial" => tutorial_params}) do
  #   changeset = Tutorial.changeset(%Tutorial{}, tutorial_params)
  #
  #   case Repo.insert(changeset) do
  #     {:ok, _tutorial} ->
  #       conn
  #       |> put_flash(:info, "Tutorial created successfully.")
  #       |> redirect(to: tutorial_path(conn, :index))
  #     {:error, changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end
  #
  # def show(conn, %{"id" => id}) do
  #   tutorial = Repo.get!(Tutorial, id)
  #   render(conn, "show.html", tutorial: tutorial)
  # end
  #
  # def edit(conn, %{"id" => id}) do
  #   tutorial = Repo.get!(Tutorial, id)
  #   changeset = Tutorial.changeset(tutorial)
  #   render(conn, "edit.html", tutorial: tutorial, changeset: changeset)
  # end
  #
  # def update(conn, %{"id" => id, "tutorial" => tutorial_params}) do
  #   tutorial = Repo.get!(Tutorial, id)
  #   changeset = Tutorial.changeset(tutorial, tutorial_params)
  #
  #   case Repo.update(changeset) do
  #     {:ok, tutorial} ->
  #       conn
  #       |> put_flash(:info, "Tutorial updated successfully.")
  #       |> redirect(to: tutorial_path(conn, :show, tutorial))
  #     {:error, changeset} ->
  #       render(conn, "edit.html", tutorial: tutorial, changeset: changeset)
  #   end
  # end
  #
  # def delete(conn, %{"id" => id}) do
  #   tutorial = Repo.get!(Tutorial, id)
  #
  #   # Here we use delete! (with a bang) because we expect
  #   # it to always work (and if it does not, it will raise).
  #   Repo.delete!(tutorial)
  #
  #   conn
  #   |> put_flash(:info, "Tutorial deleted successfully.")
  #   |> redirect(to: tutorial_path(conn, :index))
  # end
end
