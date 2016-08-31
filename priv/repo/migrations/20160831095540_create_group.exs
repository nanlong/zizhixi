defmodule Zizhixi.Repo.Migrations.CreateGroup do
  use Ecto.Migration

  def change do
    create table(:groups, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :logo, :string, null: false
      add :description, :text
      add :member_count, :integer, default: 1, null: false
      add :post_count, :integer, default: 0, null: false
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:groups, [:user_id])

  end
end
