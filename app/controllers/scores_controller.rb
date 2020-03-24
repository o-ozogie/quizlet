class ScoresController < ApplicationController
  before_action :jwt_required

  def create
    requires(question_id: Integer,
             submit_answer: String)

    question = Question.find_by_id(@params[:question_id])
    return render status: 404 unless question
    if question.scores.find_by_user_id(@payload['user_id'])
      return render status: 409
    end

    score = question.scores.create!(user_id: @payload['user_id'],
                                    result: question.answer == @params[:submit_answer],
                                    submit_answer: @params[:submit_answer])

    render json: { score_id: score.id },
           status: 201
  end

  def show
    requires(question_id: Integer)

    question = Question.find_by_id(@params[:question_id])
    return render status: 404 unless question

    submit_user_ids = []
    question.scores.each do |score|
      submit_user_ids.append(score.user.id)
    end

    response = []
    if @payload['user_id'] == question.question_set.user.id
      question.scores.each do |score|
        response.append(score_id: score.id,
                        user_name: score.user.name,
                        result: score.result,
                        submit_answer: score.submit_answer,
                        created_at: score.created_at)

      end
    elsif submit_user_ids.include?(@payload['user_id'])
      score = question.scores.find_by_user_id(@payload['user_id'])
      response.append(score_id: score.id,
                      user_name: score.user.name,
                      result: score.result,
                      submit_answer: score.submit_answer,
                      created_at: score.created_at)
    else
      return render status: 403
    end

    render json: response,
           status: 200
  end

  def update
    requires(:result, score_id: Integer)

    score = Score.find_by_id(@params[:score_id])

    return render status: 404 unless score
    unless score.question.question_set.user.id == @payload['user_id']
      return render status: 403
    end

    score.result = @params[:result]

    score.save

    render status: 200
  end
end
