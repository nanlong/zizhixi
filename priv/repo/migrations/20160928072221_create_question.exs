defmodule Zizhixi.Repo.Migrations.CreateQuestion do
  use Ecto.Migration

  def change do
    create table(:questions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :content, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:questions, [:user_id])

  end
end
