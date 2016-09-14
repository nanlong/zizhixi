defmodule Zizhixi.Repo.Migrations.CreateUserEvent do
  use Ecto.Migration

  def change do
    create table(:user_events, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :day, :date
      add :count, :integer
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:user_events, [:user_id])
    create index(:user_events, [:day])
    create unique_index(:user_events, [:day, :user_id], name: :user_events_day)

  end
end
