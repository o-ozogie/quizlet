class QuestionSetsController < ApplicationController
  before_action :jwt_required

  def create
    requires(:title, :mode)

    QuestionSet.create!(title: @params[:title],
                        description: @params[:description],
                        mode: @params[:mode])

    render status: 201
  end

  def show
    requires(set_id: Integer)

    question_set = QuestionSet.find_by_id(@params[:set_id])
    questions = []
    question_set.questions.each do |question|
      questions.append(question_id: question.id,
                       description: question.description,
                       created_at: question.created_at,
                       updated_at: question.updated_at)
    end

    render json: { title: question_set.title,
                   description: question_set.description,
                   mode: question_set.mode,
                   questions: questions },
           status: 200
  end

  def update
    requires(set_id: Integer)

    question_set = QuestionSet.find_by_id(@params[:set_id])
    return render status: 403 unless question_set.user.id == @payload['user_id']

    question_set.title = @params[:title] if @params[:title]
    question_set.description = @params[:description] if @params[:description]
    question_set.mode = @params[:mode] unless @params[:mode].nil?

    question_set.save

    render status: 200
  end

  def delete
    requires(set_id: Integer)

    question_set = QuestionSet.find_by_id(@params[:set_id])
    return render status: 403 unless question_set.user.id == @payload['user_id']

    question_set.destroy!

    render status: 200
  end
end
