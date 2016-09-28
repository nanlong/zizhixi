defmodule Zizhixi.Question do
  use Zizhixi.Web, :model

  schema "questions" do
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
    |> cast(params, [:title, :content, :user_id])
    |> validate_required([:title, :content, :user_id])
  end
end
