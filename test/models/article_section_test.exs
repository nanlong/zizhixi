defmodule Zizhixi.ArticleSectionTest do
  use Zizhixi.ModelCase

  alias Zizhixi.ArticleSection

  @valid_attrs %{content: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ArticleSection.changeset(%ArticleSection{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ArticleSection.changeset(%ArticleSection{}, @invalid_attrs)
    refute changeset.valid?
  end
end
