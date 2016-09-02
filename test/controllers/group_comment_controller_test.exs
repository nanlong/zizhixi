# defmodule Zizhixi.GroupCommentControllerTest do
#   use Zizhixi.ConnCase
#
#   alias Zizhixi.GroupComment
#   @valid_attrs %{}
#   @invalid_attrs %{}
#
#   test "creates resource and redirects when data is valid", %{conn: conn} do
#     conn = post conn, group_comment_path(conn, :create), group_comment: @valid_attrs
#     assert redirected_to(conn) == group_comment_path(conn, :index)
#     assert Repo.get_by(GroupComment, @valid_attrs)
#   end
#
#   test "does not create resource and renders errors when data is invalid", %{conn: conn} do
#     conn = post conn, group_comment_path(conn, :create), group_comment: @invalid_attrs
#     assert html_response(conn, 200) =~ "New group comment"
#   end
#
#   test "shows chosen resource", %{conn: conn} do
#     group_comment = Repo.insert! %GroupComment{}
#     conn = get conn, group_comment_path(conn, :show, group_comment)
#     assert html_response(conn, 200) =~ "Show group comment"
#   end
#
#   test "renders page not found when id is nonexistent", %{conn: conn} do
#     assert_error_sent 404, fn ->
#       get conn, group_comment_path(conn, :show, "11111111-1111-1111-1111-111111111111")
#     end
#   end
#
#   test "deletes chosen resource", %{conn: conn} do
#     group_comment = Repo.insert! %GroupComment{}
#     conn = delete conn, group_comment_path(conn, :delete, group_comment)
#     assert redirected_to(conn) == group_comment_path(conn, :index)
#     refute Repo.get(GroupComment, group_comment.id)
#   end
# end
