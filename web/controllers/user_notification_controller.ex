defmodule Zizhixi.UserNotificationController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{User, UserNotification}

  import Guardian.Plug, only: [current_resource: 1]
  import Zizhixi.Ecto.Helpers, only: [set: 4]
  import Zizhixi.Controller.Helpers, only: [redirect_to: 2]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]

  def show(conn, params) do
    current_user = current_resource(conn)

    pagination = UserNotification
    |> where(user_id: ^current_user.id)
    |> order_by([desc: :inserted_at])
    |> preload([:who])
    |> Repo.paginate(params)

    User |> set(current_user, :noread_notification_count, 0)

    conn
    |> assign(:title, "所有通知")
    |> assign(:pagination, pagination)
    |> render("show.html")
  end

  def delete(conn, %{"id" => id}) do
    IO.inspect id

    current_user = current_resource(conn)

    notification = Repo.get_by!(UserNotification, %{id: id, user_id: current_user.id})

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(notification)

    conn
    |> put_flash(:info, "删除通知成功.")
    |> redirect_to(user_notification_path(conn, :show))
  end

  def delete(conn, _params) do
    current_user = current_resource(conn)
    notifications = UserNotification
    |> where(user_id: ^current_user.id)
    |> Repo.all

    Enum.map(notifications, fn notification ->
      Repo.delete(notification)
    end)

    conn
    |> put_flash(:info, "清空通知成功.")
    |> redirect(to: user_notification_path(conn, :show))
  end
end
