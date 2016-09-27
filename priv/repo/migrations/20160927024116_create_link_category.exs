defmodule Zizhixi.Repo.Migrations.CreateLinkCategory do
  use Ecto.Migration

  def change do
    create table(:link_categories, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :index, :string
      add :category_id, references(:link_categories, on_delete: :nothing, type: :binary_id), null: true

      timestamps()
    end
    create index(:link_categories, [:category_id])

  end
end
