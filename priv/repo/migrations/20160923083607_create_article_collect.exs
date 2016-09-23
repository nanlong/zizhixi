defmodule Zizhixi.Repo.Migrations.CreateArticleCollect do
  use Ecto.Migration

  def change do
    create table(:article_collects, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :article_id, references(:articles, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:article_collects, [:article_id])
    create index(:article_collects, [:user_id])
    create unique_index(:article_collects, [:article_id, :user_id], name: :article_collects_ux)

    alter table(:articles) do
      add :collect_count, :integer, default: 0
    end
    create index(:articles, [:collect_count])
  end
end
