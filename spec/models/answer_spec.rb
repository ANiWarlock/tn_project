require 'rails_helper'

RSpec.describe Answer, type: :model do
  it {should belong_to :question}
  it {should belong_to :user}
  it {should have_db_index :question_id}
  it {should validate_presence_of :body}
  it {should validate_presence_of :question_id}
  it {should validate_presence_of :user_id}

  describe 'default_scope' do
    let!(:answer) { create(:answer) }
    let!(:answer2) { create(:answer) }

    it 'should start with best answer' do
      answer2.update(best: true)
      expect(Answer.all).to eq [answer2, answer]
    end
  end

  describe '.set_best' do
    let!(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    it 'sets self.best to true' do
      answer.set_best
      expect(answer.best).to eq true
    end

    it 'sets the old best_answer best attr to false'do
      answer2 = create(:answer, question: question)
      answer2.set_best
      answer.set_best
      answer2.reload

      expect(answer2.best).to be false
    end
  end
end
