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
    field :is_admin, :boolean, default: false
    field :followers_count, :integer, default: 0
    field :following_count, :integer, default: 0
    field :notification_count, :integer, default: 0
    field :noread_notification_count, :integer, default: 0

    field :account, :string, virtual: true
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    # for settings account
    field :old_password, :string, virtual: true
    field :new_password, :string, virtual: true
    field :new_password_confirmation, :string, virtual: true

    timestamps()
  end

  @regex_email ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
  @regex_mobile ~r/1\d{10}$/

  # @required_params, @optional_params

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

  def changeset(:settings_profile, struct, params) do
    required_params = [:avatar, :username, :email, :address, :description]

    struct
    |> cast(params, required_params)
    |> validate_required(required_params)
  end

  def changeset(:settings_password, struct, params) do
    struct
    |> cast(params, [:old_password, :new_password, :new_password_confirmation])
    |> validate_required([:old_password, :new_password, :new_password_confirmation])
    |> validate_password(:old_password)
    |> validate_length(:new_password, mix: 6, max: 128)
    |> validate_confirmation(:new_password)
    |> put_password_hash(:new_password, :password_hash)
  end

  def changeset(:password_reset_for_email, struct, params) do
    struct
    |> cast(params, [:email])
    |> validate_required([:email])
    |> load_user(:email)
  end

  def changeset(:password_reset, struct, params) do
    struct
    |> cast(params, [:password, :password_confirmation])
    |> validate_required([:password, :password_confirmation])
    |> validate_length(:password, mix: 6, max: 128)
    |> validate_confirmation(:password)
    |> put_password_hash(:password, :password_hash)
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

    avatar = "https://cn.gravatar.com/avatar/#{email_md5}?d=wavatar&s=200"

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
      false ->
        %{changeset | data: %__MODULE__{}}
        |> add_error(password_field, "password error")
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

  def generate_token(user, token_name \\ "user_id") do
    Phoenix.Token.sign(Zizhixi.Endpoint, token_name, user.id)
  end

  def validate_token(token, token_name \\ "user_id", max_age \\ 60 * 60 * 12) do
    Phoenix.Token.verify(Zizhixi.Endpoint, token_name, token, max_age: max_age)
  end
end
