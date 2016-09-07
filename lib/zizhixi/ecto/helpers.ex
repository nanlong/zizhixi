defmodule Zizhixi.Ecto.Helpers do
  import Ecto.Query

  alias Zizhixi.Repo


  @doc """
  设置某个字段的值
  """
  def set(model, %{:id => id}, column, value) do
    opts = [] |> Keyword.put(column, value)

    model
    |> where(id: ^id)
    |> update(set: ^opts)
    |> Repo.update_all([])
  end

  @doc """
  递增某个字段的值
  """
  def inc(model, %{:id => id}, column) do
    model
    |> where(id: ^id)
    |> inc_or_dec(:inc, column)
  end

  @doc """
  递减某个字段的值
  """
  def dec(model, %{:id => id}, column) do
    model
    |> where(id: ^id)
    |> inc_or_dec(:dec, column)
  end

  defp inc_or_dec(query, action, column, step \\ 1) do
    value = case action do
      :inc -> step
      :dec -> -step
    end

    opts = [] |> Keyword.put(column, value)

    query
    |> update(inc: ^opts)
    |> Repo.update_all([])
  end
end
