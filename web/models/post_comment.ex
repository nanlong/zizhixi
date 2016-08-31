defmodule Zizhixi.PostComment do
  use Zizhixi.Web, :model

  schema "post_comments" do
    field :content, :string
    field :praise_count, :integer
    field :is_deleted, :boolean, default: false
    belongs_to :user, Zizhixi.User
    belongs_to :post, Zizhixi.Post

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content, :praise_count, :is_deleted])
    |> validate_required([:content, :praise_count, :is_deleted])
  end
end
