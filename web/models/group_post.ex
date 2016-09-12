defmodule Zizhixi.GroupPost do
  use Zizhixi.Web, :model

  schema "group_posts" do
    field :title, :string
    field :content, :string
    field :is_deleted, :boolean, default: false
    field :latest_inserted_at, Ecto.DateTime
    field :comment_count, :integer, default: 0
    field :praise_count, :integer, default: 0
    field :watch_count, :integer, default: 0
    field :collect_count, :integer, default: 0

    belongs_to :group, Zizhixi.Group
    belongs_to :user, Zizhixi.User
    belongs_to :latest_user, Zizhixi.User

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
    |> put_change(:latest_inserted_at, Ecto.DateTime.utc)
  end
end
