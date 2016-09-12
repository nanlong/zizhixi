defmodule Zizhixi.GroupPostCollectTest do
  use Zizhixi.ModelCase

  alias Zizhixi.GroupPostCollect

  @valid_attrs %{
    post_id: "xxx",
    user_id: "xxx"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = GroupPostCollect.changeset(%GroupPostCollect{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GroupPostCollect.changeset(%GroupPostCollect{}, @invalid_attrs)
    refute changeset.valid?
  end
end
