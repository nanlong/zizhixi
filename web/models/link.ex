defmodule Zizhixi.Link do
  use Zizhixi.Web, :model

  schema "links" do
    field :name, :string
    field :href, :string
    field :description, :string
    field :is_approved, :boolean, default: false
    belongs_to :category, Zizhixi.LinkCategory

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :href, :description, :category_id])
    |> validate_required([:name, :href, :description, :category_id])
  end
end
