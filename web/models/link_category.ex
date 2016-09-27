defmodule Zizhixi.LinkCategory do
  use Zizhixi.Web, :model

  schema "link_categories" do
    field :name, :string
    field :index, :string, default: 0
    belongs_to :category, Zizhixi.LinkCategory

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :index], [:catetory_id])
    |> validate_required([:name, :index])
  end
end
