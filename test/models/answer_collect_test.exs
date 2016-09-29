defmodule Zizhixi.AnswerCollectTest do
  use Zizhixi.ModelCase

  alias Zizhixi.AnswerCollect

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = AnswerCollect.changeset(%AnswerCollect{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AnswerCollect.changeset(%AnswerCollect{}, @invalid_attrs)
    refute changeset.valid?
  end
end
