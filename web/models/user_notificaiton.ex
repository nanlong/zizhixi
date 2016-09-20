defmodule Zizhixi.UserNotificaiton do
  use Zizhixi.Web, :model

  schema "user_notifications" do
    field :where, :string
    field :do, :string
    field :waht, :string
    
    belongs_to :user, Zizhixi.User
    belongs_to :who, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:who_id, :where, :do, :waht, :user_id])
    |> validate_required([:who_id, :where, :do, :waht, :user_id])
  end
end
