defmodule Zizhixi.Repo.Migrations.AddGroupUsersGroupcountAndPraisecount do
  use Ecto.Migration

  def change do
    alter table(:group_users) do
      add :group_count, :integer, defalut: 0
      add :praise_count, :integer, default: 0
    end
    create index(:group_users, [:group_count])
    create index(:group_users, [:praise_count])
  end
end
