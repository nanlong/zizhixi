defmodule Zizhixi.ArticleCommentPraiseTest do
  use Zizhixi.ModelCase

  alias Zizhixi.ArticleCommentPraise

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ArticleCommentPraise.changeset(%ArticleCommentPraise{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ArticleCommentPraise.changeset(%ArticleCommentPraise{}, @invalid_attrs)
    refute changeset.valid?
  end
end
