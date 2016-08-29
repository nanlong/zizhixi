defmodule Zizhixi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :username, :string
      add :email, :string
      add :mobile, :string
      add :password_hash, :string
      add :avatar, :string
      add :address, :string
      add :description, :string

      timestamps()
    end
    create unique_index(:users, [:username])
    create unique_index(:users, [:email])
    create unique_index(:users, [:mobile])

  end
end
