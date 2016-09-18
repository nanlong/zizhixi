defmodule Zizhixi.Repo.Migrations.AddGroupPostsEliteAndTop do
  use Ecto.Migration

  def change do
    alter table(:group_posts) do
      add :is_elite, :boolean, defalut: false
      add :is_top, :boolean, default: false
    end
    create index(:group_posts, [:is_elite])
    create index(:group_posts, [:is_top])
  end
end
