defmodule Zizhixi.PostPraiseTest do
  use Zizhixi.ModelCase

  alias Zizhixi.PostPraise

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PostPraise.changeset(%PostPraise{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PostPraise.changeset(%PostPraise{}, @invalid_attrs)
    refute changeset.valid?
  end
end
