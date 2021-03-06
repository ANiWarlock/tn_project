require_relative '../feature_helper'

feature 'Create question', %q{
  In order to get answers from community
  As an authenticated user
  I want to be able to ask questions
} do

  let(:user) {create(:user)}

  scenario 'Authenticated user create question' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Some title'
    fill_in 'Body', with: 'Some body'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content 'Some title'
    expect(page).to have_content 'Some body'
  end

  scenario 'non-authenticated user create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end