defmodule Zizhixi.LinkCategory do
  use Zizhixi.Web, :model

  schema "link_categories" do
    field :name, :string
    field :sorted, :integer, default: 0
    belongs_to :category, Zizhixi.LinkCategory

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :sorted], [:category_id])
    |> validate_required([:name, :sorted])
  end

  def query() do
    from c in __MODULE__,
      where: is_nil(c.category_id)
  end
end
