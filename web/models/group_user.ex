defmodule Zizhixi.GroupUser do
  use Zizhixi.Web, :model

  alias Zizhixi.Repo

  schema "group_users" do
    field :post_count, :integer, default: 0
    field :comment_count, :integer, default: 0
    field :collect_count, :integer, default: 0
    field :group_count, :integer, default: 0
    field :praise_count, :integer, default: 0

    belongs_to :user, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id])
    |> validate_required([:user_id])
  end

  def get(user_id) do
    condition = %{user_id: user_id}

    struct = case Repo.get_by(__MODULE__, condition) do
      nil -> %__MODULE__{user_id: user_id}
      group_user -> group_user
    end

    {:ok, group_user} = __MODULE__.changeset(struct)
    |> Repo.insert_or_update

    group_user
  end
end
