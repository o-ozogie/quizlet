class QuestionsController < ApplicationController
  before_action :jwt_required

  def create
    requires(:score_second,
             set_id: Integer,
             description: String,
             answer: String)

    return render status: 404 unless QuestionSet.find_by_id(@params[:set_id])

    question = Question.create!(question_set_id: @params[:set_id],
                                description: @params[:description],
                                answer: @params[:answer],
                                score_second: @params[:score_second])

    render json: { question_id: question.id },
           status: 201
  end

  def show
    requires(question_id: Integer)

    question = Question.find_by_id(@params[:question_id])

    render json: { question_id: question.id,
                   question_set_id: question.question_set.id,
                   description: question.description,
                   created_at: question.created_at,
                   updated_at: question.updated_at },
           status: 200
  end

  def update
    requires(question_id: Integer)

    question = Question.find_by_id(@params[:question_id])
    return render status: 404 unless question
    unless question.question_set.user.id == @payload['user_id']
      return render status: 403
    end

    question.description = @params[:description] if @params[:description]
    question.answer = @params[:answer] if @params[:answer]
    question.score_second = @params[:score_second] unless @params[:score_second].nil?

    question.save

    render status: 200
  end

  def delete
    requires(question_id: Integer)

    question = Question.find_by_id(@params[:question_id])
    return render status: 404 unless question
    unless question.question_set.user.id == @payload['user_id']
      return render status: 403
    end

    question.destroy!

    render status: 200
  end
end
