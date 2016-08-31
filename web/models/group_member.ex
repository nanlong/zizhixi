defmodule Zizhixi.GroupMember do
  use Zizhixi.Web, :model

  schema "group_members" do
    belongs_to :group, Zizhixi.Group
    belongs_to :user, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:group_id, :user_id])
    |> validate_required([:group_id, :user_id])
  end
end
