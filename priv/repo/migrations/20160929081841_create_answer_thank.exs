defmodule Zizhixi.Repo.Migrations.CreateAnswerThank do
  use Ecto.Migration

  def change do
    create table(:answer_thanks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :answer_id, references(:answers, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:answer_thanks, [:answer_id])
    create index(:answer_thanks, [:user_id])
    create unique_index(:answer_thanks, [:answer_id, :user_id], name: :answer_thanks_ux)

    alter table(:answers) do
      add :thank_count, :integer, default: 0
    end
    create index(:answers, [:thank_count])
    
  end
end
