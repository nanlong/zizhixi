defmodule Zizhixi.Article do
  use Zizhixi.Web, :model

  schema "articles" do
    field :title, :string
    field :content, :string
    belongs_to :user, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :content])
    |> validate_required([:title, :content])
  end
end
