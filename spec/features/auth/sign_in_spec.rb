require_relative '../feature_helper'

feature 'User sign in', %q{
  In order to be able to ask questions
  As a user
  I want to be able to sign in
} do

  let(:user) {create(:user)}

  scenario 'Registered user try to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: '1222@aa.vom'
    fill_in 'Password', with: '121212'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password'
    expect(current_path).to eq new_user_session_path
  end

end