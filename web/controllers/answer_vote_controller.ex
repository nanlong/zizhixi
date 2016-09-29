defmodule Zizhixi.AnswerVoteController do
  use Zizhixi.Web, :controller
  # %{"answer_vote" => %{"status" => false or true}}
  alias Zizhixi.{Answer, AnswerVote}

  import Guardian.Plug, only: [current_resource: 1]
  import Zizhixi.Ecto.Helpers, only: [increment: 2, decrement: 2]
  import Zizhixi.Controller.Helpers, only: [redirect_to: 2]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]

  def create(conn, %{"answer_id" => answer_id, "answer_vote" => answer_vote_params}) do
    current_user = current_resource(conn)
    answer = Repo.get!(Answer, answer_id)

    res = case Repo.get_by(AnswerVote, %{answer_id: answer_id, user_id: current_user.id}) do
      nil ->
        if answer_vote_params["status"] == "true" do
          answer |> increment(:vote_count)
        end
        %AnswerVote{answer_id: answer_id, user_id: current_user.id}
      answer_vote ->
        cond do
          answer_vote.status and answer_vote_params["status"] == "false" ->
            answer |> decrement(:vote_count)
          !answer_vote.status and answer_vote_params["status"] == "true" ->
            answer |> increment(:vote_count)
          true -> answer
        end
        answer_vote
    end
    |> AnswerVote.changeset(answer_vote_params)
    |> Repo.insert_or_update

    conn |> redirect_to(question_path(conn, :show, answer.question_id))
  end

end
