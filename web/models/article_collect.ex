defmodule Zizhixi.ArticleCollect do
  use Zizhixi.Web, :model

  schema "article_collects" do
    belongs_to :article, Zizhixi.Article
    belongs_to :user, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:article_id, :user_id])
    |> validate_required([:article_id, :user_id])
  end
end
