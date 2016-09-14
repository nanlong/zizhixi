defmodule Zizhixi.UserTimeline do
  use Zizhixi.Web, :model

  alias Zizhixi.{GroupPost, GroupComment}

  schema "user_timelines" do
    field :day, Timex.Ecto.Date
    field :on, :string
    field :action, :string
    field :resource, :string

    belongs_to :user, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:day, :on, :action, :resource, :user_id])
    |> validate_required([:day, :on, :action, :resource, :user_id])
  end

  def add(%GroupPost{} = resource) do

  end

  def add(%GroupComment{} = resource) do

  end
end
