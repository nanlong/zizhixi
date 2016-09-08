defmodule Zizhixi.Repo.Migrations.AddGroupPostLatest do
  use Ecto.Migration

  def change do
    alter table(:group_posts) do
      add :latest_inserted_at, :datetime
      add :latest_user_id, references(:users, on_delete: :nothing, type: :binary_id), null: true
    end
  end
end
