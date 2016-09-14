defmodule Zizhixi.GroupTopic do
  use Zizhixi.Web, :model

  schema "group_topics" do
    field :name, :string
    field :sorted, :integer
    belongs_to :group, Zizhixi.Group

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :sorted, :group_id])
    |> validate_required([:name, :sorted, :group_id])
    |> unique_constraint(:name, name: :group_topics_name)
  end
end
