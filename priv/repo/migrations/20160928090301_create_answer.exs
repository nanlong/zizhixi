defmodule Zizhixi.Repo.Migrations.CreateAnswer do
  use Ecto.Migration

  def change do
    create table(:answers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :string
      add :question_id, references(:questions, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:answers, [:question_id])
    create index(:answers, [:user_id])

    alter table(:questions) do
      add :answer_count, :integer, default: 0
      add :latest_user_id, references(:users, on_delete: :nothing, type: :binary_id), null: true
      add :latest_answer_id, references(:answers, on_delete: :nothing, type: :binary_id), null: true
      add :latest_inserted_at, :datetime
    end
    create index(:questions, [:answer_count])
    create index(:questions, [:latest_user_id])
    create index(:questions, [:latest_answer_id])
    create index(:questions, [:latest_inserted_at])
  end
end
