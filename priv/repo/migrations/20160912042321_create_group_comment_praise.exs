defmodule Zizhixi.Repo.Migrations.CreateGroupCommentPraise do
  use Ecto.Migration

  def change do
    create table(:group_comment_praises, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :comment_id, references(:group_comments, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create unique_index(:group_comment_praises, [:comment_id, :user_id], name: :group_comment_praise)

    alter table(:group_comments) do
      add :praise_count, :integer, default: 0
    end
    create index(:group_comments, [:praise_count])

  end
end
