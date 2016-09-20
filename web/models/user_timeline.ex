defmodule Zizhixi.UserTimeline do
  use Zizhixi.Web, :model

  alias Zizhixi.{Repo, UserEvent, GroupPost, GroupComment}

  import Zizhixi.Router.Helpers
  import Phoenix.HTML
  import Phoenix.HTML.Link

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

  def create(conn, [where: where, action: action, what: what]) do
    %Zizhixi.UserTimeline{
      day: Timex.today,
      on: Zizhixi.UserNotification.format_where(conn, where),
      action: action,
      resource: format_what(conn, what),
      user_id: what.user_id
    }
    |> Repo.insert

    UserEvent.inc(what.user_id)
  end

  def format_what(conn, %GroupComment{post: post, index: index}) do
    post.title
    |> link(to: group_post_path(conn, :show, post.id) <> "#reply" <> Integer.to_string(index))
    |> safe_to_string
  end

  def format_what(conn, %GroupPost{id: id, title: title}) do
    title
    |> link(to: group_post_path(conn, :show, id))
    |> safe_to_string
  end
end
