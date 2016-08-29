defmodule Zizhixi.UserTest do
  use Zizhixi.ModelCase

  alias Zizhixi.User
  alias Zizhixi.Repo

  @signup_valid_attrs %{
    username: "Test",
    email: "test@zizhixi.com",
    password: "testpassword",
  }

  @signin_email_valid_attrs %{
    account: "test@zizhixi.com",
    password: "testpassword",
  }

  @signin_username_valid_attrs %{
    account: "Test",
    password: "testpassword",
  }

  @invalid_attrs %{}

  test "user signup" do
    changeset = User.changeset(:signup, %User{},  @signup_valid_attrs)
    assert changeset.valid?
    Repo.insert(changeset)
  end

  test "user signup error" do
    changeset = User.changeset(:signup, %User{}, @invalid_attrs)
    assert changeset.valid? == false
  end

  test "user signin" do
    changeset = User.changeset(:signup, %User{}, @signup_valid_attrs)
    Repo.insert(changeset)

    changeset = User.changeset(:signin, %User{}, @signin_username_valid_attrs)
    assert changeset.valid?

    changeset = User.changeset(:signin, %User{}, @signin_email_valid_attrs)
    assert changeset.valid?

    changeset = User.changeset(:signin, %User{}, %{@signin_username_valid_attrs | password: "123456"})
    assert changeset.valid? == false

    changeset = User.changeset(:signin, %User{}, %{@signin_email_valid_attrs | password: "123456"})
    assert changeset.valid? == false
  end

  test "user signin error" do
    changeset = User.changeset(:signin, %User{}, @invalid_attrs)
    assert changeset.valid? == false
  end

end
