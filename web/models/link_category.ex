defmodule Zizhixi.LinkCategory do
  use Zizhixi.Web, :model

  schema "link_categories" do
    field :name, :string
    field :sorted, :integer, default: 0
    belongs_to :category, Zizhixi.LinkCategory
    has_many :links, Zizhixi.Link, foreign_key: :category_id

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

  def generate(categories) do
    categories
    |> Enum.filter(fn category -> is_nil(category.category_id) end)
    |> Enum.map(fn parent ->
      childs = Enum.filter(categories, fn child ->
        child.category_id == parent.id
      end)
      Map.put_new(%{}, parent.name, (for child <- childs, do: {child.name, child.id}))
    end)
    |> Enum.reduce(&Map.merge/2)
  end
end
