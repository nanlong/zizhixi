defmodule Zizhixi.AskAnswerThank do
  use Zizhixi.Web, :model

  schema "answer_thanks" do
    belongs_to :answer, Zizhixi.AskAnswer
    belongs_to :user, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:answer_id, :user_id])
    |> validate_required([:answer_id, :user_id])
    |> unique_constraint(:answer_id, name: :answer_thanks_ux)
  end
end
