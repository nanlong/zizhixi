defmodule Zizhixi.GroupTopicTest do
  use Zizhixi.ModelCase

  alias Zizhixi.GroupTopic

  @valid_attrs %{
    name: "some content",
    sorted: 42,
    group_id: "xxx"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = GroupTopic.changeset(%GroupTopic{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GroupTopic.changeset(%GroupTopic{}, @invalid_attrs)
    refute changeset.valid?
  end
end
