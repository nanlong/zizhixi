defmodule Zizhixi.AskUser do
  use Zizhixi.Web, :model

  schema "ask_users" do
    field :question_count, :integer, default: 0
    field :answer_count, :integer, default: 0
    field :watch_count, :integer, default: 0
    field :vote_count, :integer, default: 0
    field :thank_count, :integer, default: 0
    field :collect_count, :integer, default: 0
    belongs_to :user, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id])
    |> validate_required([:user_id])
  end
end
