defmodule Zizhixi.Repo.Migrations.CreateArticleUser do
  use Ecto.Migration

  def change do
    create table(:article_users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :article_count, :integer, default: 0
      add :comment_count, :integer, default: 0
      add :praise_count, :integer, default: 0
      add :collect_count, :integer, default: 0
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:article_users, [:user_id])

  end
end
