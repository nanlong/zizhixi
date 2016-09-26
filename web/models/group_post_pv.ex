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
    create(conn, post_id, nil)
  end

  def get_ip_address(conn) do
    ip_address = Plug.Conn.get_req_header(conn, "x-forwarded-for") |> List.first

    case is_nil(ip_address) do
      true -> "127.0.0.1"
      false -> ip_address
    end
  end

  def create(conn, post_id, user_id) do
    today = Timex.today
    ip_address = get_ip_address(conn)

    query = from pv in __MODULE__, where: [day: ^today, ip: ^ip_address, post_id: ^post_id]

    query = case is_nil(user_id) do
      true -> from pv in query, where: is_nil(pv.user_id)
      false -> from pv in query, where: pv.user_id == ^user_id
    end
    
    case (query |> Ecto.Query.first |> Repo.one) do
      nil ->
        GroupPost |> inc(post_id, :pv)
        %__MODULE__{
          day: today,
          user_id: user_id,
          post_id: post_id,
          ip: ip_address
        }
      pv -> pv
    end
    |> changeset
    |> Repo.insert_or_update
  end
end
