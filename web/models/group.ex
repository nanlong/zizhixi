defmodule Zizhixi.Group do
  use Zizhixi.Web, :model

  schema "groups" do
    field :name, :string
    field :logo, :string
    field :description, :string
    field :member_count, :integer
    field :post_count, :integer
    belongs_to :user, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :logo, :description, :user_id])
    |> validate_required([:name, :logo, :description, :user_id])
    |> validate_length(:name, max: 48)
  end
end
