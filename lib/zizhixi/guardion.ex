defmodule Zizhixi.GuardianErrorHandler do

  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  alias Zizhixi.Router.Helpers

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "哎哟～ 不登录不能操作啊！")
    |> redirect(to: Helpers.account_path(conn, :signin_page))
  end
end


defmodule Zizhixi.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias Zizhixi.{Repo, User}

  require Ecto.Query

  def for_token(user = %User{}), do: { :ok, "User:#{user.id}" }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("User:" <> id), do: { :ok, User |> Repo.get(id) }
  def from_token(_), do: { :error, "Unknown resource type" }
end
