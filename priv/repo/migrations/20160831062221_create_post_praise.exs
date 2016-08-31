defmodule Zizhixi.Repo.Migrations.CreatePostPraise do
  use Ecto.Migration

  def change do
    create table(:post_praises, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :post_id, references(:posts, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:post_praises, [:post_id])
    create index(:post_praises, [:user_id])

  end
end
