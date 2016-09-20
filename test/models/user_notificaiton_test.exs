defmodule Zizhixi.UserNotificaitonTest do
  use Zizhixi.ModelCase

  alias Zizhixi.UserNotificaiton

  @valid_attrs %{do: "some content", waht: "some content", where: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserNotificaiton.changeset(%UserNotificaiton{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserNotificaiton.changeset(%UserNotificaiton{}, @invalid_attrs)
    refute changeset.valid?
  end
end
