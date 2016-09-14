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

  def add(conn, %GroupPost{} = group_post) do
    group_post = Repo.preload(group_post, [:group])

    on_url = group_path(conn, :show, group_post.group)

    on = group_post.group.name
    |> link(to: on_url)
    |> safe_to_string

    resource_url = group_post_path(conn, :show, group_post)

    resource = group_post.title
    |> link(to: resource_url)
    |> safe_to_string

    %__MODULE__{
      day: Timex.today,
      on: on,
      action: "发布了",
      resource: resource,
      user_id: group_post.user_id
    }
    |> Repo.insert

    UserEvent.inc(group_post.user_id)
  end

  def add(conn, %GroupComment{} = group_comment) do
    group_comment = Repo.preload(group_comment, [:post, post: :group])

    on_url = group_path(conn, :show, group_comment.post.group)

    on = group_comment.post.group.name
    |> link(to: on_url)
    |> safe_to_string

    resource_url = group_post_path(conn, :show, group_comment.post)

    resource = group_comment.post.title
    |> link(to: resource_url)
    |> safe_to_string

    %__MODULE__{
      day: Timex.today,
      on: on,
      action: "回复了",
      resource: resource,
      user_id: group_comment.user_id
    }
    |> Repo.insert

    UserEvent.inc(group_comment.user_id)
  end
end
