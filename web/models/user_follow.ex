defmodule Zizhixi.UserFollow do
  use Zizhixi.Web, :model

  schema "user_follows" do
    belongs_to :user, Zizhixi.User
    belongs_to :follow, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :follow_id])
    |> validate_required([:user_id, :follow_id])
    |> unique_constraint(:follow_id, name: :user_follow)
  end
end
