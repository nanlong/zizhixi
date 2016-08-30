defmodule Zizhixi.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :content, :text
      add :view_count, :integer, default: 0, null: false
      add :praise_count, :integer, default: 0, null: false
      add :collect_count, :integer, default: 0, null: false
      add :comment_count, :integer, default: 0, null: false
      add :is_approved, :boolean, default: false, null: false
      add :is_deleted, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:posts, [:user_id])
    create index(:posts, [:view_count])
    create index(:posts, [:praise_count])
    create index(:posts, [:collect_count])
    create index(:posts, [:comment_count])
    create index(:posts, [:is_approved])
    create index(:posts, [:is_deleted])

  end
end
