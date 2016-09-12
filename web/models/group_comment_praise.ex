defmodule Zizhixi.GroupCommentPraise do
  use Zizhixi.Web, :model

  schema "group_comment_praises" do
    belongs_to :comment, Zizhixi.Comment
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
    |> unique_constraint(:comment_id, name: :praise)
  end
end
