defmodule Zizhixi.PostCommentTest do
  use Zizhixi.ModelCase

  alias Zizhixi.{User, Post, PostComment}

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
    {:ok, comment} = insert_comment
    assert Repo.get(PostComment, comment.id)
  end

  defp insert_user() do
    user_params = %{
      username: "Test",
      email: "test@zizhixi.com",
      password: "testpassword",
    }

    changeset = User.changeset(:signup, %User{},  user_params)
    Repo.insert(changeset)
  end

  defp insert_post() do
    {:ok, user} = insert_user

    post_params = %{
      title: "some content",
      content: "some content",
      user_id: user.id
    }

    changeset = Post.changeset(%Post{}, post_params)
    {:ok, post} = Repo.insert(changeset)
    {:ok, user, post}
  end

  def insert_comment() do
    {:ok, user, post} = insert_post

    comment_params = %{
      content: "some content",
      user_id: user.id,
      post_id: post.id
    }

    changeset = PostComment.changeset(%PostComment{}, comment_params)
    Repo.insert(changeset)
  end
end
