defmodule Zizhixi.PostCommentTest do
  use Zizhixi.ModelCase

  alias Zizhixi.{PostComment}

  @valid_attrs %{content: "some content", post_id: "xxx", user_id: "xxx"}
  @invalid_attrs %{content: "", post_id: "", user_id: ""}

  test "changeset with valid attributes" do
    changeset = PostComment.changeset(%PostComment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PostComment.changeset(%PostComment{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "post comment create" do
    {:ok, comment} = insert
    assert Repo.get(PostComment, comment.id)
  end

  def insert() do
    {:ok, post} = Zizhixi.PostTest.insert

    comment_params = %{
      content: "some content",
      user_id: post.user_id,
      post_id: post.id
    }

    changeset = PostComment.changeset(%PostComment{}, comment_params)
    Repo.insert(changeset)
  end
end
