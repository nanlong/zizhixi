defmodule Zizhixi.Repo.Migrations.CreateUserNotification do
  use Ecto.Migration

  def change do
    create table(:user_notifications, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :where, :text
      add :action, :string
      add :what, :text
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :who_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:user_notifications, [:user_id])
    create index(:user_notifications, [:who_id])

    alter table(:users) do
      add :notification_count, :integer, default: 0
      add :noread_notification_count, :integer, default: 0
    end
  end
end
