defmodule Zizhixi.PostTest do
  use Zizhixi.ModelCase

  alias Zizhixi.{Post}

  @valid_attrs %{
    title: "some content",
    content: "some content",
  }
  @invalid_attrs %{
    title: "",
    content: ""
  }

  test "changeset with valid attributes" do
    post_params = @valid_attrs |> Map.put_new(:user_id, "xxx")
    changeset = Post.changeset(%Post{}, post_params)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Post.changeset(%Post{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "post create" do
    {:ok, post} = insert
    assert Repo.get(Post, post.id)
  end

  def insert() do
    {:ok, user} = Zizhixi.UserTest.insert
    post_params = @valid_attrs |> Map.put_new(:user_id, user.id)
    changeset = Post.changeset(%Post{}, post_params)
    Repo.insert(changeset)
  end
end
