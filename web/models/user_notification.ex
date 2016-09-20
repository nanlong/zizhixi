defmodule Zizhixi.UserNotification do
  use Zizhixi.Web, :model

  alias Zizhixi.{Repo, User, Group, GroupPost, GroupComment}

  import Zizhixi.Ecto.Helpers, only: [inc: 3]
  import Zizhixi.Router.Helpers
  import Phoenix.HTML
  import Phoenix.HTML.Link

  schema "user_notifications" do
    field :where, :string
    field :action, :string
    field :what, :string

    belongs_to :user, Zizhixi.User
    belongs_to :who, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:who_id, :where, :action, :what, :user_id])
    |> validate_required([:who_id, :where, :action, :waht, :user_id])
  end

  def create(conn, [user: %User{id: user_id}, who: %User{id: who_id}, where: where, action: action, what: what]) do
    if user_id != who_id do
      params = %{
        user_id: user_id,
        who_id: who_id,
        where: format_where(conn, where),
        action: action,
        what: format_what(conn, what)
      }

      case Repo.get_by(Zizhixi.UserNotification, params) do
        nil ->
          User |> inc(user_id, :notification_count)
          User |> inc(user_id, :noread_notification_count)

          Repo.insert(%Zizhixi.UserNotification{
            user_id: user_id,
            who_id: who_id,
            where: format_where(conn, where),
            action: action,
            what: format_what(conn, what)
          })
        user_notification -> user_notification
      end
    end
  end

  # who 关注了 你
  # who 在 xxx小组 回复了 xxx 帖子
  # who 在 xxx小组 赞了 xxx 帖子

  # who 在 xxx小组 赞了 xxx 帖子的评论

  # who 加入了 xxx小组
  # who 在 xxx小组 加精了 xxx帖子
  # who 在 xxx小组 置顶了 xxx帖子
  def format_where(_conn, nil) do
    ""
  end

  def format_where(conn, %Group{id: id, name: name}) do
    name
    |> link(to: group_path(conn, :show, id))
    |> safe_to_string
  end

  def format_what(conn, %Group{} = group) do
    format_where(conn, group)
  end

  def format_what(conn, %GroupPost{id: id, title: title}) do
    title
    |> link(to: group_post_path(conn, :show, id))
    |> safe_to_string
  end

  def format_what(conn, %GroupComment{post: post, index: index}) do
    post.title
    |> link(to: group_post_path(conn, :show, post.id) <> "#reply" <> Integer.to_string(index))
    |> safe_to_string
  end

  def format_what(_conn, %User{}) do
    "你"
  end
end
