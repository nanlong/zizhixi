defmodule Zizhixi.Repo.Migrations.CreateGroupComment do
  use Ecto.Migration

  def change do
    create table(:group_comments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :text
      add :is_deleted, :boolean, default: false, null: false
      add :post_id, references(:group_posts, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:group_comments, [:post_id])
    create index(:group_comments, [:user_id])

    alter table(:group_posts) do
      add :comment_count, :integer, default: 0, null: false
    end
    create index(:group_posts, [:comment_count])
  end
end
