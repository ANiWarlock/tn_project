require_relative '../feature_helper'

feature 'View questions', %q{
  In order to view a list of questions
  As a user
  I want to be able to see questions list
} do

  let(:questions) { create_list(:question, 2) }

  scenario 'User view questions list' do
    questions
    visit questions_path

    expect(page).to have_content(questions[0].title)
    expect(page).to have_content(questions[1].title)
  end
end