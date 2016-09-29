defmodule Zizhixi.AnswerVoteTest do
  use Zizhixi.ModelCase

  alias Zizhixi.AnswerVote

  @valid_attrs %{status: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = AnswerVote.changeset(%AnswerVote{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AnswerVote.changeset(%AnswerVote{}, @invalid_attrs)
    refute changeset.valid?
  end
end
