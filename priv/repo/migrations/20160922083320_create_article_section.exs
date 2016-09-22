defmodule Zizhixi.Repo.Migrations.CreateArticleSection do
  use Ecto.Migration

  def change do
    create table(:article_sections, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :content, :text
      add :article_id, references(:articles, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:article_sections, [:article_id])
    create index(:article_sections, [:user_id])

  end
end
