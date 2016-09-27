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

Enum.map(Repo.all(User), fn user ->
  if is_nil(user.is_admin) do
    User |> set(user, :is_admin, true)
  end
end)
