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

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :content, :view_count, :praise_count, :collect_count, :comment_count, :is_approved, :is_deleted])
    |> validate_required([:title, :content, :view_count, :praise_count, :collect_count, :comment_count, :is_approved, :is_deleted])
  end
end
