defmodule Zizhixi.GroupPostTest do
  use Zizhixi.ModelCase

  alias Zizhixi.GroupPost

  @valid_attrs %{
    title: "some content",
    content: "some content",
    group_id: "xxx",
    user_id: "xxx"
  }
  @invalid_attrs %{
    title: "",
    content: "",
    group_id: "",
    user_id: ""
  }

  test "changeset with valid attributes" do
    changeset = GroupPost.changeset(%GroupPost{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GroupPost.changeset(%GroupPost{}, @invalid_attrs)
    refute changeset.valid?
  end
end
