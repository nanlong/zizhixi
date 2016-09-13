defmodule Zizhixi.UserFollowTest do
  use Zizhixi.ModelCase

  alias Zizhixi.UserFollow

  @valid_attrs %{
    user_id: "xxx",
    follow_id: "xxx"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserFollow.changeset(%UserFollow{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserFollow.changeset(%UserFollow{}, @invalid_attrs)
    refute changeset.valid?
  end
end
