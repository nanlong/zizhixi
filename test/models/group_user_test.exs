defmodule Zizhixi.GroupUserTest do
  use Zizhixi.ModelCase

  alias Zizhixi.GroupUser

  @valid_attrs %{collect_count: 42, comment_count: 42, post_count: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = GroupUser.changeset(%GroupUser{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GroupUser.changeset(%GroupUser{}, @invalid_attrs)
    refute changeset.valid?
  end
end
