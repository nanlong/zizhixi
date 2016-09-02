defmodule Zizhixi.GroupCommentTest do
  use Zizhixi.ModelCase

  alias Zizhixi.GroupComment

  @valid_attrs %{
    content: "some content",
    post_id: "xxx",
    user_id: "xxx",
  }
  @invalid_attrs %{
    content: "",
    post_id: "",
    user_id: ""
  }

  test "changeset with valid attributes" do
    changeset = GroupComment.changeset(%GroupComment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GroupComment.changeset(%GroupComment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
