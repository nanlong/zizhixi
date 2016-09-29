defmodule Zizhixi.Answer do
  use Zizhixi.Web, :model

  schema "answers" do
    field :content, :string
    field :thank_count, :integer, default: 0

    belongs_to :question, Zizhixi.Question
    belongs_to :user, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content, :question_id, :user_id])
    |> validate_required([:content, :question_id, :user_id])
  end
end
