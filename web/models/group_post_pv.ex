defmodule Zizhixi.GroupPostPV do
  use Zizhixi.Web, :model

  alias Zizhixi.{Repo, User, GroupPost}
  import Zizhixi.Ecto.Helpers, only: [inc: 3]

  schema "group_posts_pv" do
    field :day, Timex.Ecto.Date
    field :ip, :string
    belongs_to :post, Zizhixi.GroupPost
    belongs_to :user, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:day, :ip, :post_id], [:user_id])
    |> validate_required([:day, :ip, :post_id])
  end

  def create(conn, %GroupPost{id: post_id}, %User{id: user_id}) do
    create(conn, post_id, user_id)
  end

  def create(conn, %GroupPost{id: post_id}, nil) do
    nil
  end

  def create(conn, post_id, user_id) do
    ip_address = Plug.Conn.get_req_header(conn, "x-forwarded-for") |> List.first

    params = %{
      day: Timex.today,
      post_id: post_id,
      user_id: user_id
    }

    params = case is_nil(ip_address) do
      true -> Map.put_new(params, :ip, "127.0.0.1")
      false -> Map.put_new(params, :ip, ip_address)
    end

    case Repo.get_by(__MODULE__, params) do
      nil ->
        GroupPost |> inc(post_id, :pv)
        %__MODULE__{}
      pv -> pv
    end
    |> changeset(params)
    |> Repo.insert_or_update

  end

end
