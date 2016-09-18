defmodule Zizhixi.Repo.Migrations.CreateGroupUser do
  use Ecto.Migration

  def change do
    create table(:group_users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :post_count, :integer, default: 0
      add :comment_count, :integer, default: 0
      add :collect_count, :integer, default: 0
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:group_users, [:user_id])

  end
end
