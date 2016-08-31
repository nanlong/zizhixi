defmodule Zizhixi.PostCommentPraiseTest do
  use Zizhixi.ModelCase

  alias Zizhixi.PostCommentPraise

  @valid_attrs %{post_comment_id: "xxx", user_id: "xxx"}
  @invalid_attrs %{post_comment_id: "", user_id: ""}

  test "changeset with valid attributes" do
    changeset = PostCommentPraise.changeset(%PostCommentPraise{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PostCommentPraise.changeset(%PostCommentPraise{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "praise create successful" do
    {:ok, post_comment} = Zizhixi.PostCommentTest.insert
    params = %{post_comment_id: post_comment.id, user_id: post_comment.user_id}
    changeset = PostCommentPraise.changeset(%PostCommentPraise{}, params)
    assert changeset.valid?
    Repo.insert(changeset)
    assert PostCommentPraise |> Repo.get_by(params)
  end
end
