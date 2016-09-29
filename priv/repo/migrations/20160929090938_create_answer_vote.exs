defmodule Zizhixi.Repo.Migrations.CreateAnswerVote do
  use Ecto.Migration

  def change do
    create table(:answer_votes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :status, :boolean, default: false, null: false
      add :answer_id, references(:answers, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:answer_votes, [:answer_id])
    create index(:answer_votes, [:user_id])
    create unique_index(:answer_votes, [:answer_id, :user_id], name: :answer_votes_ux)

    alter table(:answers) do
      add :vote_count, :integer, default: 0
    end
    create index(:answers, [:vote_count])

  end
end
