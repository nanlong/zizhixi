defmodule Zizhixi.PostCommentControllerTest do
  use Zizhixi.ConnCase

  # alias Zizhixi.PostComment
  # @valid_attrs %{}
  # @invalid_attrs %{}
  #
  # test "lists all entries on index", %{conn: conn} do
  #   conn = get conn, post_comment_path(conn, :index)
  #   assert html_response(conn, 200) =~ "Listing post comments"
  # end
  #
  # test "renders form for new resources", %{conn: conn} do
  #   conn = get conn, post_comment_path(conn, :new)
  #   assert html_response(conn, 200) =~ "New post comment"
  # end
  #
  # test "creates resource and redirects when data is valid", %{conn: conn} do
  #   conn = post conn, post_comment_path(conn, :create), post_comment: @valid_attrs
  #   assert redirected_to(conn) == post_comment_path(conn, :index)
  #   assert Repo.get_by(PostComment, @valid_attrs)
  # end
  #
  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, post_comment_path(conn, :create), post_comment: @invalid_attrs
  #   assert html_response(conn, 200) =~ "New post comment"
  # end
  #
  # test "shows chosen resource", %{conn: conn} do
  #   post_comment = Repo.insert! %PostComment{}
  #   conn = get conn, post_comment_path(conn, :show, post_comment)
  #   assert html_response(conn, 200) =~ "Show post comment"
  # end
  #
  # test "renders page not found when id is nonexistent", %{conn: conn} do
  #   assert_error_sent 404, fn ->
  #     get conn, post_comment_path(conn, :show, "11111111-1111-1111-1111-111111111111")
  #   end
  # end
  #
  # test "renders form for editing chosen resource", %{conn: conn} do
  #   post_comment = Repo.insert! %PostComment{}
  #   conn = get conn, post_comment_path(conn, :edit, post_comment)
  #   assert html_response(conn, 200) =~ "Edit post comment"
  # end
  #
  # test "updates chosen resource and redirects when data is valid", %{conn: conn} do
  #   post_comment = Repo.insert! %PostComment{}
  #   conn = put conn, post_comment_path(conn, :update, post_comment), post_comment: @valid_attrs
  #   assert redirected_to(conn) == post_comment_path(conn, :show, post_comment)
  #   assert Repo.get_by(PostComment, @valid_attrs)
  # end
  #
  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   post_comment = Repo.insert! %PostComment{}
  #   conn = put conn, post_comment_path(conn, :update, post_comment), post_comment: @invalid_attrs
  #   assert html_response(conn, 200) =~ "Edit post comment"
  # end
  #
  # test "deletes chosen resource", %{conn: conn} do
  #   post_comment = Repo.insert! %PostComment{}
  #   conn = delete conn, post_comment_path(conn, :delete, post_comment)
  #   assert redirected_to(conn) == post_comment_path(conn, :index)
  #   refute Repo.get(PostComment, post_comment.id)
  # end
end
