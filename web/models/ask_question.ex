defmodule Zizhixi.AskQuestion do
  use Zizhixi.Web, :model

  schema "questions" do
    field :title, :string
    field :content, :string
    field :pv, :integer, default: 0
    field :answer_count, :integer, default: 0
    field :watch_count, :integer, default: 0
    field :latest_inserted_at, Timex.Ecto.DateTime

    belongs_to :user, Zizhixi.User
    belongs_to :latest_user, Zizhixi.User
    belongs_to :latest_answer, Zizhixi.AskAnswer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :content, :user_id])
    |> validate_required([:title, :content, :user_id])
    |> put_change(:latest_inserted_at, Timex.now)
  end
end
