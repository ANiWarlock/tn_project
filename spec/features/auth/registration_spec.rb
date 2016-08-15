require 'rails_helper'

feature 'User registration', %q{
  In order to ask questions and give answers
  As a registered user
  I want to be able to register
} do

  let(:user_attr) {attributes_for(:user)}
  let(:user) {create(:user)}

  scenario 'New user try to register' do
    visit new_user_registration_path
    fill_in 'Email', with: user_attr[:email]
    fill_in 'Password', with: user_attr[:password]
    fill_in 'Password confirmation', with: user_attr[:password_confirmation]
    click_on 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')
  end

  scenario 'Registered user try to register' do
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content('Email has already been taken')
  end
end