defmodule Zizhixi.AskAnswerCollectView do
  use Zizhixi.Web, :view

  def render("index.json", %{answer_collects: answer_collects}) do
    %{data: render_many(answer_collects, Zizhixi.AnswerCollectView, "answer_collect.json")}
  end

  def render("show.json", %{answer_collect: answer_collect}) do
    %{data: render_one(answer_collect, Zizhixi.AnswerCollectView, "answer_collect.json")}
  end

  def render("answer_collect.json", %{answer_collect: answer_collect}) do
    %{id: answer_collect.id,
      answer_id: answer_collect.answer_id,
      user_id: answer_collect.user_id}
  end
end
