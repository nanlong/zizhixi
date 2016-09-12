defmodule Zizhixi.Repo.Migrations.CreateGroupPostWatch do
  use Ecto.Migration

  def change do
    create table(:group_post_watchs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :post_id, references(:group_posts, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:group_post_watchs, [:post_id])
    create index(:group_post_watchs, [:user_id])
    create unique_index(:group_post_watchs, [:post_id, :user_id], name: :group_post_watch)

    alter table(:group_posts) do
      add :watch_count, :integer, default: 0
    end
    create index(:group_posts, [:watch_count])
  end
end
