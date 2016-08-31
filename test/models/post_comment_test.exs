defmodule Zizhixi.PostCommentTest do
  use Zizhixi.ModelCase

  alias Zizhixi.PostComment

  @valid_attrs %{content: "some content", is_deleted: true, praise_count: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PostComment.changeset(%PostComment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PostComment.changeset(%PostComment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
