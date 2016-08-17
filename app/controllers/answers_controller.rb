class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:new, :create]

  def new
    @answer = @question.answers.build
  end

  def create

    @answer = @question.answers.build(answer_params)
    @answer.user_id = current_user.id
    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
      redirect_to @question
    else
      p @answer.errors
      render :new
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user == @answer.user
      @answer.destroy
      flash[:notice] = 'Your answer successfully deleted.'
    else
      flash[:notice] = 'You are not the author.'
    end
    redirect_to question_path(@answer.question)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end
