defmodule Zizhixi.ArticlePV do
  use Zizhixi.Web, :model

  alias Zizhixi.{Repo, User, Article}
  import Zizhixi.Ecto.Helpers, only: [inc: 3]

  schema "articles_pv" do
    field :day, Timex.Ecto.DateTime
    field :ip, :string
    belongs_to :article, Zizhixi.Article
    belongs_to :user, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:day, :ip, :article_id], [:user_id])
    |> validate_required([:day, :ip, :article_id])
  end

  def create(conn, %Article{id: article_id}, %User{id: user_id}) do
    create(conn, article_id, user_id)
  end

  def create(_conn, %Article{id: _article_id}, nil) do
    nil
  end

  def create(conn, article_id, user_id) do
    ip_address = Plug.Conn.get_req_header(conn, "x-forwarded-for") |> List.first

    params = %{
      day: Timex.today,
      article_id: article_id,
      user_id: user_id
    }

    params = case is_nil(ip_address) do
      true -> Map.put_new(params, :ip, "127.0.0.1")
      false -> Map.put_new(params, :ip, ip_address)
    end

    case Repo.get_by(__MODULE__, params) do
      nil ->
        Article |> inc(article_id, :pv)
        %__MODULE__{}
      pv -> pv
    end
    |> changeset(params)
    |> Repo.insert_or_update
  end
end
