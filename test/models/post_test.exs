defmodule Zizhixi.PostTest do
  use Zizhixi.ModelCase

  alias Zizhixi.Post

  @valid_attrs %{collect_count: 42, comment_count: 42, content: "some content", is_approved: true, is_deleted: true, praise_count: 42, title: "some content", view_count: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Post.changeset(%Post{}, @invalid_attrs)
    refute changeset.valid?
  end
end
