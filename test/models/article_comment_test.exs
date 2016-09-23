defmodule Zizhixi.ArticleCommentTest do
  use Zizhixi.ModelCase

  alias Zizhixi.ArticleComment

  @valid_attrs %{content: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ArticleComment.changeset(%ArticleComment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ArticleComment.changeset(%ArticleComment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
