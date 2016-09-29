defmodule Zizhixi.Repo.Migrations.CreateQuestionPV do
  use Ecto.Migration

  def change do
    create table(:questions_pv, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :day, :datetime
      add :ip, :string
      add :question_id, references(:questions, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:questions_pv, [:day])
    create index(:questions_pv, [:ip])
    create index(:questions_pv, [:question_id])
    create index(:questions_pv, [:user_id])
    create unique_index(:questions_pv, [:day, :ip, :question_id, :user_id], name: :questions_pv_ux)

    alter table(:questions) do
      add :pv, :integer, defalut: 0
    end
    create index(:questions, [:pv])
  end
end
