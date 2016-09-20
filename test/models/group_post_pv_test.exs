defmodule Zizhixi.GroupPostPVTest do
  use Zizhixi.ModelCase

  alias Zizhixi.GroupPostPV

  @valid_attrs %{day: %{day: 17, month: 4, year: 2010}, ip: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = GroupPostPV.changeset(%GroupPostPV{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GroupPostPV.changeset(%GroupPostPV{}, @invalid_attrs)
    refute changeset.valid?
  end
end
