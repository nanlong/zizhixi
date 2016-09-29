defmodule Zizhixi.Repo.Migrations.CreateQuestionWatch do
  use Ecto.Migration

  def change do
    create table(:question_watches, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :question_id, references(:questions, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:question_watches, [:question_id])
    create index(:question_watches, [:user_id])
    create unique_index(:question_watches, [:question_id, :user_id], name: :question_watches_ux)

    alter table(:questions) do
      add :watch_count, :integer, default: 0
    end
    create index(:questions, [:watch_count])

  end
end
