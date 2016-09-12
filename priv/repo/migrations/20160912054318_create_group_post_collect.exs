defmodule Zizhixi.Repo.Migrations.CreateGroupPostCollect do
  use Ecto.Migration

  def change do
    create table(:group_post_collects, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :post_id, references(:group_posts, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:group_post_collects, [:post_id])
    create index(:group_post_collects, [:user_id])
    create unique_index(:group_post_collects, [:post_id, :user_id], name: :group_post_collect)

    alter table(:group_posts) do
      add :collect_count, :integer, default: 0
    end
    create index(:group_posts, [:collect_count])
  end
end
