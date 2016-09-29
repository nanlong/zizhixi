defmodule Zizhixi.QuestionWatch do
  use Zizhixi.Web, :model

  schema "question_watches" do
    belongs_to :question, Zizhixi.Question
    belongs_to :user, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:question_id, :user_id])
    |> validate_required([:question_id, :user_id])
    |> unique_constraint(:question_id, name: :question_watches_watch)
  end
end
