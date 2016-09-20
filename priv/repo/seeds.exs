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
alias Zizhixi.{Repo, GroupMember, GroupUser, GroupPost, GroupComment, GroupMember,
  GroupPostCollect, GroupPostPraise, User}
import Zizhixi.Ecto.Helpers, only: [set: 4]
import Ecto.Query

# Enum.map(Repo.all(GroupUser), fn user ->
#   group_count = (from m in GroupMember, where: m.user_id == ^user.user_id, select: count(m.id)) |> Repo.one
#   GroupUser |> set(user, :group_count, group_count)
#
#   praise_count = (from p in GroupPostPraise, where: p.user_id == ^user.user_id, select: count(p.id)) |> Repo.one
#   GroupUser |> set(user, :praise_count, praise_count)
#
#   post_count = (from p in GroupPost, where: p.user_id == ^user.user_id, select: count(p.id)) |> Repo.one
#   GroupUser |> set(user, :post_count, post_count)
#
#   comment_count = (from c in GroupComment, where: c.user_id == ^user.user_id, select: count(c.id)) |> Repo.one
#   GroupUser |> set(user, :comment_count, comment_count)
#
#   collect_count = (from p in GroupPostCollect, where: p.user_id == ^user.user_id, select: count(p.id)) |> Repo.one
#   GroupUser |> set(user, :collect_count, collect_count)
# end)
#
#
# Enum.map(Repo.all(GroupPost), fn post ->
#   if is_nil(post.is_elite) do
#     GroupPost |> set(post, :is_elite, false)
#   end
#
#   if is_nil(post.is_top) do
#     GroupPost |> set(post, :is_top, false)
#   end
#
#   if is_nil(post.pv) do
#     GroupPost |> set(post, :pv, 0)
#   end
# end)
#
# Enum.map(Repo.all(GroupMember), fn member ->
#   post_count = (from p in GroupPost,
#     where: p.user_id == ^member.user_id and p.group_id == ^member.group_id,
#     select: count(p.id))
#     |> Repo.one
#   GroupMember |> set(member, :post_count, post_count)
#
#   comment_count = (from c in GroupComment,
#     join: p in GroupPost, on: c.post_id == p.id,
#     where: c.user_id == ^member.user_id and p.group_id == ^member.group_id,
#     select: count(c.id))
#     |> Repo.one
#   GroupMember |> set(member, :comment_count, comment_count)
# end)

Enum.map(Repo.all(User), fn user ->
  if is_nil(user.notification_count) do
    User |> set(user, :notification_count, 0)
  end

  if is_nil(user.noread_notification_count) do
    User |> set(user, :noread_notification_count, 0)
  end
end)

Enum.map(Repo.all(GroupComment), fn comment ->
  if is_nil(comment.index) or comment.index == 0 do
    index = comment_count = (from c in GroupComment,
      where: c.post_id == ^comment.post_id and c.inserted_at <= ^comment.inserted_at,
      select: count(c.id)) |> Repo.one
    GroupComment |> set(comment, :index, index)
  end
end)
