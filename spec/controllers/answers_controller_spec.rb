require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do

      it 'saves the new answer in the database'do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(@user.answers, :count).by(1)
      end

      it 'redirects to question path' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do

      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
      end

      it 're-renders new view'do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }
        expect(response).to redirect_to question
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'by author' do
      it 'deletes answer' do
        answer.update(user_id: @user.id)
        expect{ delete :destroy, params: { id: answer } }.to change(question.answers, :count).by(-1)
      end

      it 'redirects to question view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'by not author' do
      it 'does not delete answer' do
        answer#.update(user_id: @user.id)
        expect{ delete :destroy, params: { id: answer } }.to change(question.answers, :count).by(0)
      end

      it 'redirects to question view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end
end
