defmodule Zizhixi.GroupComment do
  use Zizhixi.Web, :model

  alias Zizhixi.{Repo, User, UserNotification}

  schema "group_comments" do
    field :content, :string
    field :index, :integer, default: 0
    field :is_deleted, :boolean, default: false
    field :praise_count, :integer, default: 0

    belongs_to :post, Zizhixi.GroupPost
    belongs_to :user, Zizhixi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content, :post_id, :user_id], [:index])
    |> validate_required([:content, :post_id, :user_id])
    |> validate_length(:content, max: 240)
    |> replace_at_user(:content)
  end

  def replace_at_user(%Ecto.Changeset{valid?: true} = changeset, field) do
    content = get_field(changeset, field)

    new_content = Regex.replace(~r/@(\S+)\s?/, content, fn str, username ->
      case Repo.get_by(User, %{username: username}) do
        nil -> str
        user -> "<a href='/users/#{username}'>@#{username}</a> "
      end
    end)

    changeset |> put_change(:content, new_content)
  end

  def replace_at_user(%Ecto.Changeset{valid?: false} = changeset, field) do
    changeset
  end

  def at_user(conn, group_comment) do
    group_comment = group_comment |> Repo.preload(:user)

    usernames = Regex.scan(~r/@(\S+)<\/a>?/, group_comment.content) |> Enum.uniq

    Enum.map(usernames, fn [_, username] ->
      case Repo.get_by(User, %{username: username}) do
        nil -> nil
        user ->
          if user != group_comment.user do
            UserNotification.create(conn,
              user: user,
              who: group_comment.user,
              where: group_comment,
              action: "@了",
              what: user
            )
          end
      end
    end)
  end
end
