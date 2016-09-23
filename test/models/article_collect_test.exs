defmodule Zizhixi.ArticleCollectTest do
  use Zizhixi.ModelCase

  alias Zizhixi.ArticleCollect

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ArticleCollect.changeset(%ArticleCollect{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ArticleCollect.changeset(%ArticleCollect{}, @invalid_attrs)
    refute changeset.valid?
  end
end
