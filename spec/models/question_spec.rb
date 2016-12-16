require 'rails_helper'

RSpec.describe Question, type: :model do
  it {should have_many(:answers).dependent(:destroy)}
  it {should belong_to(:user)}
  it {should have_many(:attachments)}

  it {should validate_presence_of :title}
  it {should validate_presence_of :body}
  it {should validate_presence_of :user_id}

  it {should accept_nested_attributes_for :attachments}

  describe '.best_answer' do
    let!(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    it 'it returns the answer with best eq true' do
      answer.update(best: true)
      question.reload

      expect(question.best_answer).to eq answer
    end
  end
end
