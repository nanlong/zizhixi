defmodule Zizhixi.AccountController do
  use Zizhixi.Web, :controller

  alias Zizhixi.User

  def signup_page(conn, _params) do
    changeset = User.changeset(:signup, %User{})
    render conn, "signup.html", changeset: changeset
  end

  def signup(conn, %{"user" => user_params}) do
    changeset = User.changeset(:signup, %User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "#{user.email} 注册成功")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render conn, "signup.html", changeset: changeset
    end
  end

  def signin_page(conn, _params) do
    changeset = User.changeset(:signin, %User{})
    render conn, "signin.html", changeset: changeset
  end

  def signin(conn, %{"user" => user_params}) do
    changeset = User.changeset(:signin, %User{}, user_params)

    case changeset.valid? do
      true ->
        conn
        |> put_flash(:info, "#{changeset.data.username} 登录成功")
        |> redirect(to: page_path(conn, :index))
      false ->
        changeset = %{changeset | action: :signin}
        render conn, "signin.html", changeset: changeset
    end

  end

  # def index(conn, _params) do
  #   users = Repo.all(Account)
  #   render(conn, "index.html", users: users)
  # end
  #
  # def new(conn, _params) do
  #   changeset = Account.changeset(%Account{})
  #   render(conn, "new.html", changeset: changeset)
  # end
  #
  # def create(conn, %{"account" => account_params}) do
  #   changeset = Account.changeset(%Account{}, account_params)
  #
  #   case Repo.insert(changeset) do
  #     {:ok, _account} ->
  #       conn
  #       |> put_flash(:info, "Account created successfully.")
  #       |> redirect(to: account_path(conn, :index))
  #     {:error, changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end
  #
  # def show(conn, %{"id" => id}) do
  #   account = Repo.get!(Account, id)
  #   render(conn, "show.html", account: account)
  # end
  #
  # def edit(conn, %{"id" => id}) do
  #   account = Repo.get!(Account, id)
  #   changeset = Account.changeset(account)
  #   render(conn, "edit.html", account: account, changeset: changeset)
  # end
  #
  # def update(conn, %{"id" => id, "account" => account_params}) do
  #   account = Repo.get!(Account, id)
  #   changeset = Account.changeset(account, account_params)
  #
  #   case Repo.update(changeset) do
  #     {:ok, account} ->
  #       conn
  #       |> put_flash(:info, "Account updated successfully.")
  #       |> redirect(to: account_path(conn, :show, account))
  #     {:error, changeset} ->
  #       render(conn, "edit.html", account: account, changeset: changeset)
  #   end
  # end
  #
  # def delete(conn, %{"id" => id}) do
  #   account = Repo.get!(Account, id)
  #
  #   # Here we use delete! (with a bang) because we expect
  #   # it to always work (and if it does not, it will raise).
  #   Repo.delete!(account)
  #
  #   conn
  #   |> put_flash(:info, "Account deleted successfully.")
  #   |> redirect(to: account_path(conn, :index))
  # end
end
