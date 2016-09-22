defmodule Zizhixi.ArticleSection do
  use Zizhixi.Web, :model

  schema "article_sections" do
    field :title, :string
    field :content, :string
    belongs_to :article, Zizhixi.Article
    belongs_to :user, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :content, :article_id, :user_id])
    |> validate_required([:title, :content, :article_id, :user_id])
  end
end
