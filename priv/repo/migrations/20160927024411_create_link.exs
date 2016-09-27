defmodule Zizhixi.Repo.Migrations.CreateLink do
  use Ecto.Migration

  def change do
    create table(:links, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :href, :text
      add :description, :text
      add :category_id, references(:link_categories, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end
    create index(:links, [:category_id])

  end
end
