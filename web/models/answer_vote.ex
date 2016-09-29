defmodule Zizhixi.AnswerVote do
  use Zizhixi.Web, :model

  schema "answer_votes" do
    field :status, :boolean, default: false
    belongs_to :answer, Zizhixi.Answer
    belongs_to :user, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:status, :answer_id, :user_id])
    |> validate_required([:status, :answer_id, :user_id])
    |> unique_constraint(:answer_id, name: :answer_votes_ux)
  end
end
