require_relative '../feature_helper'

feature 'Create answer', %q{
  In order to help community
  As an authenticated user
  I want to be able to give answers
} do

  let(:user) { create(:user) }
  let!(:question) { create(:question) }

  scenario 'Authenticated user create answer', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'Some answer body'
    click_on 'Give answer'

    expect(page).to have_content('Your answer successfully created.')
    within '.answers' do
      expect(page).to have_content('Some answer body')
    end
    expect(current_path).to eq question_path(question)
  end

  scenario 'Non-authenticated user create answer' do
    visit question_path(question)
    click_on 'Give answer'

    expect(page).to have_content('You need to sign in or sign up before continuing.')
    expect(current_path).to eq new_user_session_path
  end
end