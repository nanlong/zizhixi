defmodule Zizhixi.PostCommentPraise do
  use Zizhixi.Web, :model

  schema "post_comment_praises" do
    belongs_to :post_comment, Zizhixi.PostComment
    belongs_to :user, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:post_comment_id, :user_id])
    |> validate_required([:post_comment_id, :user_id])
  end
end
