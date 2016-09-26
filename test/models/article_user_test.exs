defmodule Zizhixi.ArticleUserTest do
  use Zizhixi.ModelCase

  alias Zizhixi.ArticleUser

  @valid_attrs %{article_count: 42, collect_count: 42, comment_count: 42, praise_count: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ArticleUser.changeset(%ArticleUser{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ArticleUser.changeset(%ArticleUser{}, @invalid_attrs)
    refute changeset.valid?
  end
end
