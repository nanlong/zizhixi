defmodule Zizhixi.ArticlePVTest do
  use Zizhixi.ModelCase

  alias Zizhixi.ArticlePV

  @valid_attrs %{day: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, ip: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ArticlePV.changeset(%ArticlePV{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ArticlePV.changeset(%ArticlePV{}, @invalid_attrs)
    refute changeset.valid?
  end
end
