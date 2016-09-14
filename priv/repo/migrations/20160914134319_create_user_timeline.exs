defmodule Zizhixi.Repo.Migrations.CreateUserTimeline do
  use Ecto.Migration

  def change do
    create table(:user_timelines, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :day, :date
      add :on, :text
      add :action, :string
      add :resource, :text
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:user_timelines, [:user_id])
    create index(:user_timelines, [:day])
  end
end
