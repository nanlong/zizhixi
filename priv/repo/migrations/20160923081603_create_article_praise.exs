defmodule Zizhixi.Repo.Migrations.CreateArticlePraise do
  use Ecto.Migration

  def change do
    create table(:article_praises, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :article_id, references(:articles, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:article_praises, [:article_id])
    create index(:article_praises, [:user_id])

    alter table(:articles) do
      add :praise_count, :integer, default: 0
    end
    create index(:articles, [:praise_count])
  end
end
