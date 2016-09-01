defmodule Zizhixi.Repo.Migrations.CreateGroupPost do
  use Ecto.Migration

  def change do
    create table(:group_posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :content, :text
      add :is_deleted, :boolean, default: false, null: false
      add :group_id, references(:groups, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:group_posts, [:group_id])
    create index(:group_posts, [:user_id])

  end
end
