defmodule Zizhixi.GroupTopicControllerTest do
  use Zizhixi.ConnCase

  # alias Zizhixi.GroupTopic
  # @valid_attrs %{}
  # @invalid_attrs %{}
  #
  # test "lists all entries on index", %{conn: conn} do
  #   conn = get conn, group_topic_path(conn, :index)
  #   assert html_response(conn, 200) =~ "Listing grop topics"
  # end
  #
  # test "renders form for new resources", %{conn: conn} do
  #   conn = get conn, group_topic_path(conn, :new)
  #   assert html_response(conn, 200) =~ "New group topic"
  # end
  #
  # test "creates resource and redirects when data is valid", %{conn: conn} do
  #   conn = post conn, group_topic_path(conn, :create), group_topic: @valid_attrs
  #   assert redirected_to(conn) == group_topic_path(conn, :index)
  #   assert Repo.get_by(GroupTopic, @valid_attrs)
  # end
  #
  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, group_topic_path(conn, :create), group_topic: @invalid_attrs
  #   assert html_response(conn, 200) =~ "New group topic"
  # end
  #
  # test "shows chosen resource", %{conn: conn} do
  #   group_topic = Repo.insert! %GroupTopic{}
  #   conn = get conn, group_topic_path(conn, :show, group_topic)
  #   assert html_response(conn, 200) =~ "Show group topic"
  # end
  #
  # test "renders page not found when id is nonexistent", %{conn: conn} do
  #   assert_error_sent 404, fn ->
  #     get conn, group_topic_path(conn, :show, "11111111-1111-1111-1111-111111111111")
  #   end
  # end
  #
  # test "renders form for editing chosen resource", %{conn: conn} do
  #   group_topic = Repo.insert! %GroupTopic{}
  #   conn = get conn, group_topic_path(conn, :edit, group_topic)
  #   assert html_response(conn, 200) =~ "Edit group topic"
  # end
  #
  # test "updates chosen resource and redirects when data is valid", %{conn: conn} do
  #   group_topic = Repo.insert! %GroupTopic{}
  #   conn = put conn, group_topic_path(conn, :update, group_topic), group_topic: @valid_attrs
  #   assert redirected_to(conn) == group_topic_path(conn, :show, group_topic)
  #   assert Repo.get_by(GroupTopic, @valid_attrs)
  # end
  #
  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   group_topic = Repo.insert! %GroupTopic{}
  #   conn = put conn, group_topic_path(conn, :update, group_topic), group_topic: @invalid_attrs
  #   assert html_response(conn, 200) =~ "Edit group topic"
  # end
  #
  # test "deletes chosen resource", %{conn: conn} do
  #   group_topic = Repo.insert! %GroupTopic{}
  #   conn = delete conn, group_topic_path(conn, :delete, group_topic)
  #   assert redirected_to(conn) == group_topic_path(conn, :index)
  #   refute Repo.get(GroupTopic, group_topic.id)
  # end
end
