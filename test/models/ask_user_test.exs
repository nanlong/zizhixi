defmodule Zizhixi.AskUserTest do
  use Zizhixi.ModelCase

  alias Zizhixi.AskUser

  @valid_attrs %{answer_count: 42, collect_count: "some content", question_count: 42, thank_count: "some content", vote_count: "some content", watch_count: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = AskUser.changeset(%AskUser{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AskUser.changeset(%AskUser{}, @invalid_attrs)
    refute changeset.valid?
  end
end
