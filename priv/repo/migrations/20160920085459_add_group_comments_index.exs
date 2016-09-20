defmodule Zizhixi.Repo.Migrations.AddGroupCommentsIndex do
  use Ecto.Migration

  def change do
    alter table(:group_comments) do
      add :index, :integer, default: 0
    end

    create index(:group_comments, [:index])
  end
end
