defmodule Zizhixi.ArticlePraiseTest do
  use Zizhixi.ModelCase

  alias Zizhixi.ArticlePraise

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ArticlePraise.changeset(%ArticlePraise{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ArticlePraise.changeset(%ArticlePraise{}, @invalid_attrs)
    refute changeset.valid?
  end
end
