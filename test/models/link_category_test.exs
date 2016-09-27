defmodule Zizhixi.LinkCategoryTest do
  use Zizhixi.ModelCase

  alias Zizhixi.LinkCategory

  @valid_attrs %{index: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = LinkCategory.changeset(%LinkCategory{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = LinkCategory.changeset(%LinkCategory{}, @invalid_attrs)
    refute changeset.valid?
  end
end
