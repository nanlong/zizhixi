defmodule Zizhixi.GroupPostCollect do
  use Zizhixi.Web, :model

  schema "group_post_collects" do
    belongs_to :post, Zizhixi.Post
    belongs_to :user, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:post_id, :user_id])
    |> validate_required([:post_id, :user_id])
    |> unique_constraint(:post_id, name: :group_post_collect)
  end
end
