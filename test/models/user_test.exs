defmodule Zizhixi.UserTest do
  use Zizhixi.ModelCase

  alias Zizhixi.User

  @valid_attrs %{address: "some content", avatar: "some content", description: "some content", email: "some content", mobile: "some content", password_hash: "some content", username: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
