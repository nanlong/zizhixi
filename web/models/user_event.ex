defmodule Zizhixi.UserEvent do
  use Zizhixi.Web, :model

  alias Zizhixi.Repo

  schema "user_events" do
    field :day, Timex.Ecto.Date
    field :count, :integer
    belongs_to :user, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:day, :count, :user_id])
    |> validate_required([:day, :count, :user_id])
  end

  @doc """
  UserEvent.inc(current_user.id)
  UserEvent.inc(current_user.id, ~D(2016-09-14))
  UserEvent.inc(current_user.id, Timex.today)
  """
  def inc(user_id, day \\ nil) do
    day = day || Timex.today
    condition = %{user_id: user_id, day: day}

    {struct, params} = case Repo.get_by(__MODULE__, condition) do
      nil -> {%__MODULE__{user_id: user_id, day: day}, %{count: 1}}
      user_event -> {user_event, %{count: user_event.count + 1}}
    end

    __MODULE__.changeset(struct, params)
    |> Repo.insert_or_update
  end
end
