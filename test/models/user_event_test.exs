defmodule Zizhixi.UserEventTest do
  use Zizhixi.ModelCase

  alias Zizhixi.UserEvent

  @valid_attrs %{
    count: 42,
    day: ~D(2016-09-14),
    user_id: "xxx"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserEvent.changeset(%UserEvent{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserEvent.changeset(%UserEvent{}, @invalid_attrs)
    refute changeset.valid?
  end
end
