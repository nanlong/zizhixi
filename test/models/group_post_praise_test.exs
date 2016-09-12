defmodule Zizhixi.GroupPostPraiseTest do
  use Zizhixi.ModelCase

  alias Zizhixi.GroupPostPraise

  @valid_attrs %{
    post_id: "xxx",
    user_id: "xxx"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = GroupPostPraise.changeset(%GroupPostPraise{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GroupPostPraise.changeset(%GroupPostPraise{}, @invalid_attrs)
    refute changeset.valid?
  end
end
