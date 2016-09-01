defmodule Zizhixi.GroupPost do
  use Zizhixi.Web, :model

  schema "group_posts" do
    field :title, :string
    field :content, :string
    field :is_deleted, :boolean, default: false
    belongs_to :group, Zizhixi.Group
    belongs_to :user, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :content, :group_id, :user_id])
    |> validate_required([:title, :content, :group_id, :user_id])
    |> validate_length(:title, max: 120)
  end
end
