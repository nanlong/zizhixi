defmodule Zizhixi.Repo.Migrations.AddGroupMembersPostcountAndCommentcount do
  use Ecto.Migration

  def change do
    alter table(:group_members) do
      add :post_count, :integer, defalut: 0
      add :comment_count, :integer, default: 0
    end
    create index(:group_members, [:post_count])
    create index(:group_members, [:comment_count])
  end
end
