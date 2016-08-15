require 'rails_helper'

feature 'Delete answer', %q{
  In order to delete answer
  As an answer author
  I want to be able to delete answer
} do

  let(:question) {create(:question_with_answers)}
  scenario 'Answer author try to delete answer' do
    visit question_path(question)

  end

  scenario "User try to delete another's user answer" do

  end
end