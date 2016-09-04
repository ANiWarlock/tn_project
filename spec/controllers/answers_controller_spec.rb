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
        expect{ delete :destroy, params: { id: answer }, format: :js }.to change(@user.answers, :count).by(-1)
      end

      it 'renders destroy template' do
        expect( delete :destroy, params: { id: answer }, format: :js ).to render_template :destroy
      end
    end

    context 'by not author' do
      it 'does not delete answer' do
        answer
        expect{ delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders destroy template' do
        expect( delete :destroy, params: { id: answer }, format: :js ).to render_template :destroy
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    context 'by author' do
      before { answer.update(user: @user) }

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

    context 'by not author' do
      it 'redirects to question view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        expect(response).to redirect_to answer.question
      end

      it 'does not update the answer' do
        old_answer = answer
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        answer.reload
        expect(answer.body).to eq old_answer.body
      end
    end
  end

  describe 'PATCH #best' do
    sign_in_user
    context 'by question author' do
      it 'sets answer to be the question.best_answer' do
        question.update(user: @user)
        patch :best, params: { id: answer, question_id: question }, format: :js
        question.reload

        expect(question.best_answer).to eq answer
      end
    end

    context 'by not question author' do
      it 'does not change best answer' do
        patch :best, params: { id: answer, question_id: question }, format: :js

        expect(response.response_code).to eq 403
      end
    end
  end
end
