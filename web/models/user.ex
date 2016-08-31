defmodule Zizhixi.User do
  use Zizhixi.Web, :model

  alias Ecto.Changeset
  alias Zizhixi.Repo

  schema "users" do
    field :username, :string  # 用户名
    field :email, :string  # 邮箱
    field :mobile, :string  # 手机号
    field :password_hash, :string  # 密码
    field :avatar, :string  # 头像
    field :address, :string  # 地址
    field :description, :string  # 个人简介

    field :account, :string, virtual: true
    field :password, :string, virtual: true

    timestamps()
  end

  @regex_email ~r/.+@[^\.]+.*/
  @regex_mobile ~r/1\d{10}$/

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(action, struct, params \\ %{})

  @doc """
  用户注册
  """
  def changeset(:signup, struct, params) do
    struct
    |> cast(params, [:username, :email, :password])
    |> validate_required([:username, :email, :password])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> validate_length(:username, min: 2, max: 16)
    |> validate_format(:email, @regex_email)
    |> validate_length(:password, mix: 6, max: 128)
    |> put_avatar(:email, :avatar)
    |> put_password_hash(:password, :password_hash)
  end

  @doc """
  用户登录
  """
  def changeset(:signin, struct, params) do
    struct
    |> cast(params, [:account, :password])
    |> validate_required([:account, :password])
    |> load_user(:account)
    |> validate_password(:password)
  end

  @doc """
  为用户设置头像
  """
  def put_avatar(%Changeset{valid?: true} = changeset, email_field, avatar_field) do
    email = get_field(changeset, email_field)
    |> String.trim
    |> String.downcase

    email_md5 = :crypto.hash(:md5, email)
    |> Base.encode16(case: :lower)

    avatar = "https://gravatar.tycdn.net/avatar/#{email_md5}?d=wavatar&s=#200"

    changeset |> put_change(avatar_field, avatar)
  end

  def put_avatar(%Changeset{valid?: false} = changeset, _email_field, _avatar_field) do
    changeset
  end

  @doc """
  为用户加密密码
  """
  def put_password_hash(%Changeset{valid?: true} = changeset, password_field, password_hash_field) do
    password_hash = changeset
    |> get_field(password_field)
    |> Comeonin.Bcrypt.hashpwsalt

    changeset |> put_change(password_hash_field, password_hash)
  end

  def put_password_hash(%Changeset{valid?: false} = changeset, _password_field, _password_hash_field) do
    changeset
  end

  @doc """
  验证密码
  """
  def verify_password?(password, password_hash) do
    Comeonin.Bcrypt.checkpw(password, password_hash)
  end

  @doc """
  验证密码
  """
  def validate_password(%Changeset{valid?: true} = changeset, password_field) do
    password = get_field(changeset, password_field)

    case verify_password?(password, changeset.data.password_hash) do
      true -> changeset
      false -> changeset |> add_error(password_field, "密码错误")
    end
  end

  def validate_password(%Changeset{valid?: false} = changeset, _password_field) do
    changeset
  end

  @doc """
  通过账号获取用户，支持用户名，邮箱，手机号
  """
  def get_by_account(account) do
    cond do
      String.match?(account, @regex_email) ->
        __MODULE__ |> Repo.get_by(email: account)
      String.match?(account, @regex_mobile) ->
        __MODULE__ |> Repo.get_by(mobile: account)
      true ->
        __MODULE__ |> Repo.get_by(username: account)
    end
  end

  @doc """
  加载用户
  """
  def load_user(%Changeset{valid?: true} = changeset, field) do
    case changeset |> get_field(field) |> get_by_account do
      nil -> changeset |> add_error(field, "用户不存在")
      user -> %{changeset | data: user}
    end
  end

  def load_user(%Changeset{valid?: false} = changeset, _field) do
    changeset
  end
end
