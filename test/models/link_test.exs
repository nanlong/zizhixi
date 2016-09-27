defmodule Zizhixi.LinkTest do
  use Zizhixi.ModelCase

  alias Zizhixi.Link

  @valid_attrs %{description: "some content", href: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Link.changeset(%Link{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Link.changeset(%Link{}, @invalid_attrs)
    refute changeset.valid?
  end
end
