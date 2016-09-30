defmodule Zizhixi.Repo.Migrations.CreateAskUser do
  use Ecto.Migration

  def change do
    create table(:ask_users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :question_count, :integer, default: 0
      add :answer_count, :integer, default: 0
      add :watch_count, :integer, default: 0
      add :vote_count, :integer, default: 0
      add :thank_count, :integer, default: 0
      add :collect_count, :integer, default: 0
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:ask_users, [:user_id])

  end
end
