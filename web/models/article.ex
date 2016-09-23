defmodule Zizhixi.Article do
  use Zizhixi.Web, :model

  schema "articles" do
    field :title, :string
    field :content, :string
    field :comment_count, :integer, default: 0
    field :praise_count, :integer, default: 0
    field :latest_inserted_at, Timex.Ecto.DateTime

    belongs_to :user, Zizhixi.User
    belongs_to :latest_user, Zizhixi.User
    has_many :sections, Zizhixi.ArticleSection

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :content, :user_id])
    |> validate_required([:title, :content, :user_id])
    |> validate_length(:title, max: 240)
    |> put_change(:latest_inserted_at, Timex.now)
  end
end
