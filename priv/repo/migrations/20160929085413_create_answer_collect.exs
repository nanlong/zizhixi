defmodule Zizhixi.Repo.Migrations.CreateAnswerCollect do
  use Ecto.Migration

  def change do
    create table(:answer_collects, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :answer_id, references(:answers, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:answer_collects, [:answer_id])
    create index(:answer_collects, [:user_id])
    create unique_index(:answer_collects, [:answer_id, :user_id], name: :answer_collects_ux)

    alter table(:answers) do
      add :collect_count, :integer, default: 0
    end
    create index(:answers, [:collect_count])

  end
end
