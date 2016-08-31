defmodule Zizhixi.Repo.Migrations.CreatePostCommentPraise do
  use Ecto.Migration

  def change do
    create table(:post_comment_praises, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :post_comment_id, references(:post_comments, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:post_comment_praises, [:post_comment_id])
    create index(:post_comment_praises, [:user_id])

  end
end
