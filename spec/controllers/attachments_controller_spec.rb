require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    sign_in_user
    let!(:question){ create :question }

    before do
      question.attachments.create!(file: File.open("#{Rails.root}/spec/spec_helper.rb"))
    end

    context 'by author' do
      before { question.update(user_id: @user.id) }

      it 'deletes attachment' do
        expect { delete :destroy, params: { id: question.attachments.first }, format: :js }.to change(Attachment, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: question.attachments.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'by not author' do
      it 'does not delete attachment' do
        expect { delete :destroy, params: { id: question.attachments.first }, format: :js }.to_not change(Attachment, :count)
      end
    end
  end
end