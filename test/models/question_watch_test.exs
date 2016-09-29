defmodule Zizhixi.QuestionWatchTest do
  use Zizhixi.ModelCase

  alias Zizhixi.QuestionWatch

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = QuestionWatch.changeset(%QuestionWatch{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = QuestionWatch.changeset(%QuestionWatch{}, @invalid_attrs)
    refute changeset.valid?
  end
end
