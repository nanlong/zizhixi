defmodule Zizhixi.Repo.Migrations.CreateArticlePV do
  use Ecto.Migration

  def change do
    create table(:articles_pv, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :day, :datetime
      add :ip, :string
      add :article_id, references(:articles, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: true

      timestamps()
    end
    create index(:articles_pv, [:day])
    create index(:articles_pv, [:ip])
    create index(:articles_pv, [:article_id])
    create index(:articles_pv, [:user_id])
    create unique_index(:articles_pv, [:day, :ip, :article_id, :user_id], name: :articles_pv_ux)

    alter table(:articles) do
      add :pv, :integer, defalut: 0
    end
    create index(:articles, [:pv])
  end
end
