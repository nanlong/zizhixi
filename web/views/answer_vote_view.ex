defmodule Zizhixi.AnswerVoteView do
  use Zizhixi.Web, :view

  def render("index.json", %{answer_votes: answer_votes}) do
    %{data: render_many(answer_votes, Zizhixi.AnswerVoteView, "answer_vote.json")}
  end

  def render("show.json", %{answer_vote: answer_vote}) do
    %{data: render_one(answer_vote, Zizhixi.AnswerVoteView, "answer_vote.json")}
  end

  def render("answer_vote.json", %{answer_vote: answer_vote}) do
    %{id: answer_vote.id,
      answer_id: answer_vote.answer_id,
      user_id: answer_vote.user_id,
      status: answer_vote.status}
  end
end
