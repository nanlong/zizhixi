defmodule Zizhixi.AskAnswerVoteController do
  use Zizhixi.Web, :controller

  alias Zizhixi.AskUser
  alias Zizhixi.AskAnswer, as: Answer
  alias Zizhixi.AskAnswerVote, as: AnswerVote

  import Guardian.Plug, only: [current_resource: 1]
  import Zizhixi.Ecto.Helpers, only: [increment: 2, decrement: 2]
  import Zizhixi.Controller.Helpers, only: [redirect_to: 2]

  plug Guardian.Plug.EnsureAuthenticated, [handler: Zizhixi.Guardian.ErrorHandler]

  def create(conn, %{"ask_answer_id" => answer_id, "ask_answer_vote" => answer_vote_params}) do
    current_user = current_resource(conn)
    answer = Repo.get!(Answer, answer_id)

    case Repo.get_by(AnswerVote, %{answer_id: answer_id, user_id: current_user.id}) do
      nil ->
        if answer_vote_params["status"] == "true" do
          answer |> increment(:vote_count)
          AskUser.get(current_user) |> increment(:vote_count)
        end
        %AnswerVote{answer_id: answer_id, user_id: current_user.id}
      answer_vote ->
        cond do
          answer_vote.status and answer_vote_params["status"] == "false" ->
            answer |> decrement(:vote_count)
            AskUser.get(current_user) |> decrement(:vote_count)
          !answer_vote.status and answer_vote_params["status"] == "true" ->
            answer |> increment(:vote_count)
            AskUser.get(current_user) |> increment(:vote_count)
          true -> answer
        end
        answer_vote
    end
    |> AnswerVote.changeset(answer_vote_params)
    |> Repo.insert_or_update

    conn |> redirect_to(ask_question_path(conn, :show, answer.question_id))
  end

end
