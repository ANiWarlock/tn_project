require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do

      it 'belong to logged in user' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(@user.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do

      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }, format: :js }.to_not change(Answer, :count)
      end

      it 'render create template'do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'by author' do
      it 'deletes answer' do
        answer.update(user_id: @user.id)
        expect{ delete :destroy, params: { id: answer } }.to change(@user.answers, :count).by(-1)
      end

      it 'redirects to question view' do
        expect( delete :destroy, params: { id: answer } ).to redirect_to answer.question
      end
    end

    context 'by not author' do
      it 'does not delete answer' do
        answer
        expect{ delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirects to question view' do
        expect( delete :destroy, params: { id: answer } ).to redirect_to answer.question
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    it 'assigns the requested answer to @answer' do
      patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'changes answer attributes' do
      patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
      expect(response).to render_template :update
    end
  end
end
