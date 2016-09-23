defmodule Zizhixi.Repo.Migrations.CreateArticleCommentPraise do
  use Ecto.Migration

  def change do
    create table(:article_comment_praises, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :comment_id, references(:article_comments, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:article_comment_praises, [:comment_id])
    create index(:article_comment_praises, [:user_id])

    alter table(:article_comments) do
      add :praise_count, :integer, default: 0
    end
    create index(:article_comments, [:praise_count])
  end
end
