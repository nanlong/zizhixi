defmodule Zizhixi.QuestionPVTest do
  use Zizhixi.ModelCase

  alias Zizhixi.QuestionPV

  @valid_attrs %{day: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, ip: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = QuestionPV.changeset(%QuestionPV{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = QuestionPV.changeset(%QuestionPV{}, @invalid_attrs)
    refute changeset.valid?
  end
end
