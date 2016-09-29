defmodule Zizhixi.QuestionPV do
  use Zizhixi.Web, :model

  alias Zizhixi.{Repo, User, Question}
  import Zizhixi.Ecto.Helpers, only: [inc: 3]

  schema "questions_pv" do
    field :day, Timex.Ecto.DateTime
    field :ip, :string
    belongs_to :question, Zizhixi.Question
    belongs_to :user, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:day, :ip, :question_id], [:user_id])
    |> validate_required([:day, :ip, :question_id])
  end

  def get_ip_address(conn) do
    ip_address = Plug.Conn.get_req_header(conn, "x-forwarded-for") |> List.first

    case is_nil(ip_address) do
      true -> "127.0.0.1"
      false -> ip_address
    end
  end

  def create(conn, %Question{id: question_id}, %User{id: user_id}) do
    create(conn, question_id, user_id)
  end

  def create(conn, %Question{id: question_id}, nil) do
    create(conn, question_id, nil)
  end

  def create(conn, question_id, user_id) do
    today = Timex.today
    ip_address = get_ip_address(conn)

    query = from pv in __MODULE__, where: [day: ^today, ip: ^ip_address, question_id: ^question_id]

    query = case is_nil(user_id) do
      true -> from pv in query, where: is_nil(pv.user_id)
      false -> from pv in query, where: pv.user_id == ^user_id
    end

    case (query |> Ecto.Query.first |> Repo.one) do
      nil ->
        Question |> inc(question_id, :pv)
        %__MODULE__{
          day: today,
          user_id: user_id,
          question_id: question_id,
          ip: ip_address
        }
      pv -> pv
    end
    |> changeset
    |> Repo.insert_or_update
  end
end
