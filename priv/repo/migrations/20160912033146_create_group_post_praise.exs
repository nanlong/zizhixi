defmodule Zizhixi.Repo.Migrations.CreateGroupPostPraise do
  use Ecto.Migration

  def change do
    create table(:group_post_praises, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :post_id, references(:group_posts, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create unique_index(:group_post_praises, [:post_id, :user_id], name: :group_post_praise)

    alter table(:group_posts) do
      add :praise_count, :integer, default: 0
    end
    create index(:group_posts, [:praise_count])
  end
end
