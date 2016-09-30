defmodule Zizhixi.AskUserController do
  use Zizhixi.Web, :controller

  alias Zizhixi.AskUser



  def show(conn, %{"id" => id}) do
    ask_user = Repo.get!(AskUser, id)
    render(conn, "show.html", ask_user: ask_user)
  end
end
