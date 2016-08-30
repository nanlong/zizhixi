defmodule Zizhixi.Post do
  use Zizhixi.Web, :model

  schema "posts" do
    field :title, :string  # 标题
    field :content, :string  # 内容
    field :view_count, :integer, default: 0  # 浏览量
    field :praise_count, :integer, default: 0  # 点赞数量
    field :collect_count, :integer, default: 0  # 收藏数量
    field :comment_count, :integer, default: 0  # 评论数量
    field :is_approved, :boolean, default: false  # 是否审核通过
    field :is_deleted, :boolean, default: false  #  是否被删除
    belongs_to :user, Zizhixi.User

    timestamps()
  end

  def changeset(action, struct, params \\ %{})

  def changeset(:create, struct, params) do
    struct
    |> cast(params, [:title, :content, :user_id])
    |> validate_required([:title, :content, :user_id])
    |> validate_length(:title, min: 1, max: 240)
    |> validate_length(:content, min: 1)
  end

  def changeset(:update, struct, params) do
    struct
    |> cast(params, [:title, :content])
    |> validate_required([:title, :content])
    |> validate_length(:title, min: 1, max: 240)
    |> validate_length(:content, min: 1)
  end
end
