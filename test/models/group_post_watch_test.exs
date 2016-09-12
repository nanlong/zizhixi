defmodule Zizhixi.GroupPostWatchTest do
  use Zizhixi.ModelCase

  alias Zizhixi.GroupPostWatch

  @valid_attrs %{
    post_id: "xxx",
    user_id: "xxx"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = GroupPostWatch.changeset(%GroupPostWatch{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GroupPostWatch.changeset(%GroupPostWatch{}, @invalid_attrs)
    refute changeset.valid?
  end
end
