defmodule Zizhixi.PostPraiseController do
  use Zizhixi.Web, :controller

  alias Zizhixi.{Post, PostPraise}

  import Zizhixi.Sqlalchemy, only: [inc: 3, dec: 3]

  def index(conn, %{"post_id" => post_id}) do
    post = Repo.get!(Post, post_id)
    post_praises = Repo.all(PostPraise)
    render(conn, "index.html", post: post, post_praises: post_praises)
  end

  def create(conn, %{"post_id" => post_id}) do
    post = Repo.get!(Post, post_id)
    current_user = Guardian.Plug.current_resource(conn)
    params = %{
      post_id: post_id,
      user_id: current_user.id
    }
    changeset = PostPraise.changeset(%PostPraise{}, params)

    conn = case Repo.insert(changeset) do
      {:ok, post_praise} ->
        Post |> inc(post, :praise_count)
        conn |> put_flash(:info, "点赞成功")
      {:error, changeset} ->
        conn |> put_flash(:danger, "点赞失败")
    end

    conn |> redirect(to: post_path(conn, :show, post))
  end

  def delete(conn, %{"post_id" => post_id, "id" => id}) do
    post = Repo.get!(Post, post_id)
    current_user = Guardian.Plug.current_resource(conn)
    params = %{id: id, post_id: post_id, user_id: current_user.id}
    post_praise = Repo.get_by!(PostPraise, params)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post_praise)
    Post |> dec(post, :praise_count)
    
    conn |> redirect(to: post_path(conn, :show, post))
  end
end
