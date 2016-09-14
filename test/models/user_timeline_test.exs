defmodule Zizhixi.UserTimelineTest do
  use Zizhixi.ModelCase

  alias Zizhixi.UserTimeline

  @valid_attrs %{
    action: "some content",
    day: ~D(2016-09-14), 
    on: "some content",
    resource: "some content",
    user_id: "xxx"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserTimeline.changeset(%UserTimeline{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserTimeline.changeset(%UserTimeline{}, @invalid_attrs)
    refute changeset.valid?
  end
end
