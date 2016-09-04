class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_answer, only: [:best, :update, :destroy]

  def best
    if current_user.author_of?(@answer.question)
      @answer.set_best
    else
      render json: {}, status: :forbidden
    end
  end

  def create
    @answer = @question.answers.build(answer_params.merge(user: current_user))
    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
    end
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    else
      redirect_to @answer.question
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer successfully deleted.'
    else
      flash[:notice] = 'You are not the author.'
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end
