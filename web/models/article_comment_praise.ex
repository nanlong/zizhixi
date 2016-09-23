defmodule Zizhixi.ArticleCommentPraise do
  use Zizhixi.Web, :model

  schema "article_comment_praises" do
    belongs_to :comment, Zizhixi.ArticleComment
    belongs_to :user, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:comment_id, :user_id])
    |> validate_required([:comment_id, :user_id])
  end
end
