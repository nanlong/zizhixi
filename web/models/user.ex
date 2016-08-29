defmodule Zizhixi.User do
  use Zizhixi.Web, :model

  schema "users" do
    field :username, :string
    field :email, :string
    field :mobile, :string
    field :password_hash, :string
    field :avatar, :string
    field :address, :string
    field :description, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :email, :mobile, :password_hash, :avatar, :address, :description])
    |> validate_required([:username, :email, :mobile, :password_hash, :avatar, :address, :description])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> unique_constraint(:mobile)
  end
end
