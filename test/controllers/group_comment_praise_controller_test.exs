defmodule Zizhixi.GroupCommentPraiseControllerTest do
  use Zizhixi.ConnCase

  # alias Zizhixi.GroupCommentPraise
  # @valid_attrs %{}
  # @invalid_attrs %{}
  #
  # test "lists all entries on index", %{conn: conn} do
  #   conn = get conn, group_comment_praise_path(conn, :index)
  #   assert html_response(conn, 200) =~ "Listing group comment praises"
  # end
  #
  # test "renders form for new resources", %{conn: conn} do
  #   conn = get conn, group_comment_praise_path(conn, :new)
  #   assert html_response(conn, 200) =~ "New group comment praise"
  # end
  #
  # test "creates resource and redirects when data is valid", %{conn: conn} do
  #   conn = post conn, group_comment_praise_path(conn, :create), group_comment_praise: @valid_attrs
  #   assert redirected_to(conn) == group_comment_praise_path(conn, :index)
  #   assert Repo.get_by(GroupCommentPraise, @valid_attrs)
  # end
  #
  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, group_comment_praise_path(conn, :create), group_comment_praise: @invalid_attrs
  #   assert html_response(conn, 200) =~ "New group comment praise"
  # end
  #
  # test "shows chosen resource", %{conn: conn} do
  #   group_comment_praise = Repo.insert! %GroupCommentPraise{}
  #   conn = get conn, group_comment_praise_path(conn, :show, group_comment_praise)
  #   assert html_response(conn, 200) =~ "Show group comment praise"
  # end
  #
  # test "renders page not found when id is nonexistent", %{conn: conn} do
  #   assert_error_sent 404, fn ->
  #     get conn, group_comment_praise_path(conn, :show, "11111111-1111-1111-1111-111111111111")
  #   end
  # end
  #
  # test "renders form for editing chosen resource", %{conn: conn} do
  #   group_comment_praise = Repo.insert! %GroupCommentPraise{}
  #   conn = get conn, group_comment_praise_path(conn, :edit, group_comment_praise)
  #   assert html_response(conn, 200) =~ "Edit group comment praise"
  # end
  #
  # test "updates chosen resource and redirects when data is valid", %{conn: conn} do
  #   group_comment_praise = Repo.insert! %GroupCommentPraise{}
  #   conn = put conn, group_comment_praise_path(conn, :update, group_comment_praise), group_comment_praise: @valid_attrs
  #   assert redirected_to(conn) == group_comment_praise_path(conn, :show, group_comment_praise)
  #   assert Repo.get_by(GroupCommentPraise, @valid_attrs)
  # end
  #
  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   group_comment_praise = Repo.insert! %GroupCommentPraise{}
  #   conn = put conn, group_comment_praise_path(conn, :update, group_comment_praise), group_comment_praise: @invalid_attrs
  #   assert html_response(conn, 200) =~ "Edit group comment praise"
  # end
  #
  # test "deletes chosen resource", %{conn: conn} do
  #   group_comment_praise = Repo.insert! %GroupCommentPraise{}
  #   conn = delete conn, group_comment_praise_path(conn, :delete, group_comment_praise)
  #   assert redirected_to(conn) == group_comment_praise_path(conn, :index)
  #   refute Repo.get(GroupCommentPraise, group_comment_praise.id)
  # end
end
