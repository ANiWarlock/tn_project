require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) {create(:question)}

  describe 'GET #index' do
    let(:questions) {create_list(:question, 2)}
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: {id: question }}

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answern to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before {get :new}

    it 'assigns a new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do

      it 'belong to logged in user' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do

      it 'does not saves the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    context 'by author' do
      before { question.update(user: @user) }
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'renders update template' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'by not author' do
      before { patch :update, params: { id: question, question: attributes_for(:question) }, format: :js }

      it 'redirects to question view' do

        expect(response).to redirect_to question
      end

      it 'does not change question' do
        old_question = question
        question.reload
        expect(question.title).to eq old_question.title
        expect(question.body).to eq old_question.body
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'by author' do
      before { question.update(user_id: @user.id) }

      it 'deletes question' do
        expect { delete :destroy, params: { id: question} }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        expect( delete :destroy, params: { id: question} ).to redirect_to questions_path
      end
    end

    context 'by not author' do
      before { question }
      it 'does not delete question' do
        expect { delete :destroy, params: { id: question} }.to_not change(Question, :count)
      end

      it 'redirects to question view' do
        expect( delete :destroy, params: { id: question} ).to redirect_to question
      end
    end
  end
end
