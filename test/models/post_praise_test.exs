defmodule Zizhixi.PostPraiseTest do
  use Zizhixi.ModelCase

  alias Zizhixi.PostPraise

  @valid_attrs %{post_id: "xxx", user_id: "xxx"}
  @invalid_attrs %{post_id: "", user_id: ""}

  test "changeset with valid attributes" do
    changeset = PostPraise.changeset(%PostPraise{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PostPraise.changeset(%PostPraise{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "praise create successful" do
    {:ok, post} = Zizhixi.PostTest.insert
    params = %{post_id: post.id, user_id: post.user_id}
    changeset = PostPraise.changeset(%PostPraise{}, params)
    assert changeset.valid?
    Repo.insert(changeset)
    assert PostPraise |> Repo.get_by(params)
  end
end
