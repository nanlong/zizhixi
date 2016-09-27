defmodule Zizhixi.Repo.Migrations.AddUsersIsAdminColumn do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_admin, :boolean, defalut: false
    end
  end
end
