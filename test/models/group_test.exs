defmodule Zizhixi.GroupTest do
  use Zizhixi.ModelCase

  alias Zizhixi.Group

  @valid_attrs %{
    name: "some content",
    logo: "some content",
    description: "some content",
  }
  @invalid_attrs %{
    name: "",
    logo: "",
    description: ""
  }

  test "changeset with valid attributes" do
    params = @valid_attrs |> Map.put_new(:user_id, "xxx")
    changeset = Group.changeset(%Group{}, params)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Group.changeset(%Group{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "group create" do
    {:ok, user} = Zizhixi.UserTest.insert
    params = @valid_attrs |> Map.put_new(:user_id, user.id)
    changeset = Group.changeset(%Group{}, params)
    Repo.insert(changeset)
    assert Repo.get_by(Group, params)
  end
end
