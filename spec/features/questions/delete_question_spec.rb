require 'rails_helper'

feature 'Delete question', %q{
  In order to delete question
  As a question author
  I want to be able to delete question
} do
  let(:question) { create(:question) }

  scenario 'Question author try to delete question' do
    sign_in(question.user)
    visit question_path(question)
    click_on('Delete question')

    expect(page).to have_content('Your question successfully deleted.')
    expect(current_path).to eq questions_path
  end

  scenario "User try to delete another's user question" do
    sign_in(create(:user))
    visit question_path(question)
    click_on('Delete question')

    expect(page).to have_content('You are not the author')
    expect(current_path).to eq question_path(question)
  end

end