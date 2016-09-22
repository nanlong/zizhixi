defmodule Zizhixi.Repo.Migrations.CreateArticle do
  use Ecto.Migration

  def change do
    create table(:articles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :content, :text
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:articles, [:user_id])

  end
end
