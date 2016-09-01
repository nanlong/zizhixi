defmodule Zizhixi.Repo.Migrations.AddUniqueIndexForPraise do
  use Ecto.Migration

  def change do
    create unique_index(:post_praises, [:post_id, :user_id], name: :ux_praise_post_user)
    create unique_index(:post_comment_praises, [:post_comment_id, :user_id], name: :ux_praise_post_comment_user)
  end
end
