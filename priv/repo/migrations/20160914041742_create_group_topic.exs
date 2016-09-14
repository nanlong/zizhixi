defmodule Zizhixi.Repo.Migrations.CreateGroupTopic do
  use Ecto.Migration

  def change do
    create table(:group_topics, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :sorted, :integer, default: 0
      add :group_id, references(:groups, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:group_topics, [:group_id])
    create unique_index(:group_topics, [:name, :group_id], name: :group_topics_name)

    alter table(:group_posts) do
      add :topic_id, references(:group_topics, on_delete: :nilify_all, type: :binary_id)
    end
    create index(:group_posts, [:topic_id])
  end
end
