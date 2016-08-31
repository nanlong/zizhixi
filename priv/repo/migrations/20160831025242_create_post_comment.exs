defmodule Zizhixi.Repo.Migrations.CreatePostComment do
  use Ecto.Migration

  def change do
    create table(:post_comments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :text
      add :praise_count, :integer
      add :is_deleted, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :post_id, references(:posts, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:post_comments, [:user_id])
    create index(:post_comments, [:post_id])

  end
end
