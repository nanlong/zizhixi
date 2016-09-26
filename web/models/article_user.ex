defmodule Zizhixi.ArticleUser do
  use Zizhixi.Web, :model

  alias Zizhixi.{Repo, User}

  schema "article_users" do
    field :article_count, :integer, default: 0
    field :comment_count, :integer, default: 0
    field :praise_count, :integer, default: 0
    field :collect_count, :integer, default: 0
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

  def get(%User{id: user_id}) do
    get(user_id)
  end

  def get(user_id) when is_bitstring(user_id) do
    condition = %{user_id: user_id}

    {:ok, article_user} = case Repo.get_by(__MODULE__, condition) do
      nil -> %__MODULE__{user_id: user_id}
      article_user -> article_user
    end
    |> __MODULE__.changeset
    |> Repo.insert_or_update

    article_user
  end
end
