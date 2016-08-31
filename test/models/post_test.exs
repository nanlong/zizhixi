defmodule Zizhixi.PostTest do
  use Zizhixi.ModelCase

  alias Zizhixi.{Repo, Post, User}

  @post_create_valid_attrs %{
    title: "some content",
    content: "some content",
    user_id: ""
  }

  @post_editor_valid_attrs %{
    title: "some content",
    content: "some content",
  }

  @invalid_attrs %{}

  @user_params %{
    username: "Test",
    email: "test@zizhixi.com",
    password: "testpassword",
  }

  test "post create success and update success" do
    changeset = User.changeset(:signup, %User{},  @user_params)
    {:ok, user} = Repo.insert(changeset)

    changeset = Post.changeset(%Post{}, %{@post_create_valid_attrs | user_id: user.id})
    assert changeset.valid?
    {:ok, post} = Repo.insert(changeset)

    changeset = Post.changeset(post, @post_editor_valid_attrs)
    assert changeset.valid?
    {:ok, _} = Repo.update(changeset)
  end

  test "post create error" do
    changeset = Post.changeset(%Post{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "post update error" do
    changeset = Post.changeset(%Post{}, @invalid_attrs)
    refute changeset.valid?

    changeset = User.changeset(:signup, %User{},  @user_params)
    {:ok, user} = Repo.insert(changeset)

    changeset = Post.changeset(%Post{}, %{@post_create_valid_attrs | user_id: user.id})
    assert changeset.valid?
    {:ok, post} = Repo.insert(changeset)

    changeset = Post.changeset(post, %{title: "", content: ""})
    refute changeset.valid?
  end
end
