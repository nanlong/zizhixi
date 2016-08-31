defmodule Zizhixi.PostCommentPraiseTest do
  use Zizhixi.ModelCase

  alias Zizhixi.PostCommentPraise

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PostCommentPraise.changeset(%PostCommentPraise{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PostCommentPraise.changeset(%PostCommentPraise{}, @invalid_attrs)
    refute changeset.valid?
  end
end
