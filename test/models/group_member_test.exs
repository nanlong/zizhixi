defmodule Zizhixi.GroupMemberTest do
  use Zizhixi.ModelCase

  alias Zizhixi.GroupMember

  @valid_attrs %{
    group_id: "xxx",
    user_id: "xxx"
  }
  @invalid_attrs %{
    group_id: "",
    user_id: ""
  }

  test "changeset with valid attributes" do
    changeset = GroupMember.changeset(%GroupMember{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GroupMember.changeset(%GroupMember{}, @invalid_attrs)
    refute changeset.valid?
  end
end
