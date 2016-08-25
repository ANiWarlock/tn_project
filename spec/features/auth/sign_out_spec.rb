require_relative '../feature_helper'

feature 'User sign out', %q{
  In order to sign in with different creds
  As a user
  I want to be able to sign out
} do

  scenario 'Authenticated user try to sign out' do
    @user = create(:user)
    sign_in(@user)

    visit root_path
    click_on('Sign out')

    expect(page).to have_content('Signed out successfully.')
    expect(current_path).to eq root_path
  end
end