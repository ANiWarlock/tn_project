require_relative '../feature_helper'

feature 'Editing answer', %q{
  In order to fix errors
  As an author of answer
  I want to be able to edit answer
} do

  let(:user) { create(:user) }
  let!(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }


  describe 'Authenticated user' do
    before { sign_in user }

    scenario 'sees link to edit his answer' do
      answer.update(user: user)
      visit question_path(question)

      within '.answers' do
        expect(page).to have_link 'Edit answer'
      end
    end

    scenario 'does not see link to edit not his answer' do
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Edit answer'
      end
    end

    scenario 'try to edit his answer', js: true do
      answer.update(user: user)
      visit question_path(question)
      within '.answers' do
        click_on 'Edit answer'
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end


  scenario "Non-authenticated user try to edit answer" do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit answer'
    end
  end
end
