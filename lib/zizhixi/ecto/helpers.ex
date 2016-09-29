defmodule Zizhixi.Ecto.Helpers do
  @moduledoc """

  example:
    post = Repo.get(Post, post_id)
    Post |> inc(post, :comment_count)

    post |> inc(:comment_count)
  """
  import Ecto.Query
  import Ecto.Changeset, only: [update_change: 3]

  alias Zizhixi.Repo

  def increment(struct, field, step \\ 1) do
    params = %{}
    |> Map.put_new(field, Map.get(struct, field))
    |> Map.update!(field, &(&1 + step))

    update_struct(struct, params)
  end

  def decrement(struct, field, step \\ 1) do
    params = %{}
    |> Map.put_new(field, Map.get(struct, field))
    |> Map.update!(field, &(&1 - step))

    update_struct(struct, params)
  end

  def update_field(struct, field, value) do
    params = %{}
    |> Map.put_new(field, value)

    update_struct(struct, params)
  end

  defp update_struct(struct, params) do
    struct
    |> Ecto.Changeset.change(params)
    |> Repo.update
  end
end
