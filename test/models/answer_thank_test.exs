defmodule Zizhixi.AnswerThankTest do
  use Zizhixi.ModelCase

  alias Zizhixi.AnswerThank

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = AnswerThank.changeset(%AnswerThank{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AnswerThank.changeset(%AnswerThank{}, @invalid_attrs)
    refute changeset.valid?
  end
end
