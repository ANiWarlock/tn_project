require_relative '../feature_helper'

feature 'Choosing best answer', %q{
  In order to help community
  As an author of question
  I want to be able to choose best answer
} do

  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question) }

  before { sign_in(user) }

  scenario 'question author pick one best answer', js: true do
    visit question_path(question)

    within ".answer-#{answer.id}" do
      click_on 'Best answer!'
    end

    within '.best-answer' do
      expect(page).to have_content(answer.body)
    end
  end

  scenario 'question author change the best answer', js: true do
    answer2 = create(:answer, question: question)
    answer2.set_best
    visit question_path(question)

    within ".answer-#{answer.id}" do
      click_on 'Best answer!'
    end

    within '.best-answer' do
      expect(page).to have_content(answer.body)
      expect(page).to_not have_content(answer2.body)
    end
  end
end