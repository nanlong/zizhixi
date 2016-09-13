defmodule Zizhixi.Repo.Migrations.CreateUserFollow do
  use Ecto.Migration

  def change do
    create table(:user_follows, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :follow_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:user_follows, [:user_id])
    create index(:user_follows, [:follow_id])
    create unique_index(:user_follows, [:user_id, :follow_id], name: :user_follow)

    alter table(:users) do
      add :followers_count, :integer, default: 0
      add :following_count, :integer, default: 0
    end
    create index(:users, [:followers_count])
    create index(:users, [:following_count])
  end
end
