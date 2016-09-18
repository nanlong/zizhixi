# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Zizhixi.Repo.insert!(%Zizhixi.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Zizhixi.{Repo, GroupPost, GroupMember}
import Zizhixi.Ecto.Helpers, only: [set: 4]


Enum.map(Repo.all(GroupPost), fn post ->
  if is_nil(post.is_elite) do
    GroupPost |> set(post, :is_elite, false)
  end

  if is_nil(post.is_top) do
    GroupPost |> set(post, :is_top, false)
  end
end)

Enum.map(Repo.all(GroupMember), fn member ->
  if is_nil(member.post_count) do
    GroupMember |> set(member, :post_count, 0)
  end

  if is_nil(member.comment_count) do
    GroupMember |> set(member, :comment_count, 0)
  end
end)
