defmodule Zizhixi.Repo.Migrations.CreateGroupMember do
  use Ecto.Migration

  def change do
    create table(:group_members, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :group_id, references(:groups, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:group_members, [:group_id])
    create index(:group_members, [:user_id])

  end
end
