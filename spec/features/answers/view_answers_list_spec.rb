require 'rails_helper'

feature 'View question and answers', %q{
  In order to read answers
  As a user
  I want to be able to view list of answers
} do

  let(:question) { create(:question_with_answers) }

  scenario 'View question and answers list' do
    visit question_path(question)

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    expect(page).to have_content(question.answers[0].body)
    expect(page).to have_content(question.answers[1].body)
  end
end