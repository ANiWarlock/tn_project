require 'rails_helper'

feature 'Delete answer', %q{
  In order to delete answer
  As an answer author
  I want to be able to delete answer
} do

  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }


  scenario 'Answer author try to delete answer' do
    sign_in(answer.user)
    visit question_path(question)
    click_on('Delete answer')

    expect(page).to have_content('Your answer successfully deleted.')
    expect(current_path).to eq question_path(question)
  end

  scenario "User try to delete another's user answer" do
    sign_in(create(:user))
    visit question_path(question)

    expect(page).to_not have_content('Delete answer')
    expect(current_path).to eq question_path(question)
  end
end