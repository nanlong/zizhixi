defmodule Zizhixi.Repo.Migrations.CreateGroupPostPV do
  use Ecto.Migration

  def change do
    create table(:group_posts_pv, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :day, :date
      add :ip, :string
      add :post_id, references(:group_posts, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: true

      timestamps()
    end
    create index(:group_posts_pv, [:day])
    create index(:group_posts_pv, [:ip])
    create index(:group_posts_pv, [:post_id])
    create index(:group_posts_pv, [:user_id])
    create unique_index(:group_posts_pv, [:day, :ip, :post_id], name: :group_posts_pv_ux)

    alter table(:group_posts) do
      add :pv, :integer, defalut: 0
    end
    create index(:group_posts, [:pv])
  end
end
