defmodule Zizhixi.GroupTopicController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{Group, GroupTopic}
  import Guardian.Plug, only: [current_resource: 1]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]

  def index(conn, %{"group_id" => group_id}) do
    current_user = current_resource(conn)
    group = Repo.get_by!(Group, %{id: group_id, user_id: current_user.id})
    group_topics = GroupTopic
    |> where(group_id: ^group_id)
    |> order_by([:sorted, :inserted_at])
    |> Repo.all

    conn
    |> assign(:title, "#{group.name} - 话题管理")
    |> render("index.html", group: group, group_topics: group_topics)
  end

  def new(conn, %{"group_id" => group_id}) do
    current_user = current_resource(conn)
    group = Repo.get_by!(Group, %{id: group_id, user_id: current_user.id})
    changeset = GroupTopic.changeset(%GroupTopic{})

    conn
    |> assign(:title, "创建话题")
    |> render("new.html", group: group, changeset: changeset)
  end

  def create(conn, %{"group_id" => group_id, "group_topic" => group_topic_params}) do
    current_user = current_resource(conn)
    group = Repo.get_by!(Group, %{id: group_id, user_id: current_user.id})

    params = group_topic_params
    |> Map.put_new("group_id", group_id)

    changeset = GroupTopic.changeset(%GroupTopic{}, params)

    case Repo.insert(changeset) do
      {:ok, _group_topic} ->
        conn
        |> put_flash(:info, "话题创建成功.")
        |> redirect(to: group_topic_path(conn, :index, group))
      {:error, changeset} ->
        conn
        |> assign(:title, "创建话题")
        |> render("new.html", group: group, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    current_user = current_resource(conn)
    group_topic = Repo.get!(GroupTopic, id)
    group = Repo.get_by!(Group, %{id: group_topic.group_id, user_id: current_user.id})

    changeset = GroupTopic.changeset(group_topic)

    conn
    |> assign(:title, "#{group.name} - 话题编辑")
    |> render("edit.html", group: group, group_topic: group_topic, changeset: changeset)
  end

  def update(conn, %{"id" => id, "group_topic" => group_topic_params}) do
    current_user = current_resource(conn)
    group_topic = Repo.get!(GroupTopic, id)
    group = Repo.get_by!(Group, %{id: group_topic.group_id, user_id: current_user.id})

    changeset = GroupTopic.changeset(group_topic, group_topic_params)

    case Repo.update(changeset) do
      {:ok, _group_topic} ->
        conn
        |> put_flash(:info, "话题编辑成功.")
        |> redirect(to: group_topic_path(conn, :index, group))
      {:error, changeset} ->
        conn
        |> assign(:title, "#{group.name} - 话题编辑")
        |> render("edit.html", group: group, group_topic: group_topic, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = current_resource(conn)
    group_topic = Repo.get!(GroupTopic, id)
    group = Repo.get_by!(Group, %{id: group_topic.group_id, user_id: current_user.id})

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(group_topic)

    conn
    |> put_flash(:info, "话题删除成功.")
    |> redirect(to: group_topic_path(conn, :index, group))
  end
end
