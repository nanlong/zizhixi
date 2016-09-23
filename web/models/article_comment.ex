defmodule Zizhixi.ArticleComment do
  use Zizhixi.Web, :model

  schema "article_comments" do
    field :content, :string
    field :index, :integer, default: 0
    field :is_deleted, :boolean, default: false
    belongs_to :article, Zizhixi.Article
    belongs_to :user, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:index, :content, :article_id, :user_id])
    |> validate_required([:index, :content, :article_id, :user_id])
  end
end
