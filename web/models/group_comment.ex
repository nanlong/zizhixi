defmodule Zizhixi.GroupComment do
  use Zizhixi.Web, :model

  schema "group_comments" do
    field :content, :string
    field :is_deleted, :boolean, default: false
    field :praise_count, :integer, default: 0

    belongs_to :post, Zizhixi.GroupPost
    belongs_to :user, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content, :post_id, :user_id])
    |> validate_required([:content, :post_id, :user_id])
    |> validate_length(:content, max: 240)
  end
end
