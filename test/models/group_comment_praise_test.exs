defmodule Zizhixi.GroupCommentPraiseTest do
  use Zizhixi.ModelCase

  alias Zizhixi.GroupCommentPraise

  @valid_attrs %{
    comment_id: "xxx",
    user_id: "xxx"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = GroupCommentPraise.changeset(%GroupCommentPraise{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GroupCommentPraise.changeset(%GroupCommentPraise{}, @invalid_attrs)
    refute changeset.valid?
  end
end
