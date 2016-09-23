defmodule Zizhixi.Repo.Migrations.CreateArticleComment do
  use Ecto.Migration

  def change do
    create table(:article_comments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :text
      add :index, :integer, default: 0
      add :is_deleted, :boolean, default: false
      add :article_id, references(:articles, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:article_comments, [:article_id])
    create index(:article_comments, [:user_id])

    alter table(:articles) do
      add :comment_count, :integer, default: 0
      add :latest_inserted_at, :datetime
      add :latest_user_id, references(:users, on_delete: :nothing, type: :binary_id), null: true
    end
    create index(:articles, [:comment_count])
    create index(:articles, [:latest_inserted_at])
    create index(:articles, [:latest_user_id])
  end
end
