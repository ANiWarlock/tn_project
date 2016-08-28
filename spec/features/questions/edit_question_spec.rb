require_relative '../feature_helper'

feature 'Editing question', %q{
  In order to fix errors
  As an author of question
  I want to be able to edit question
} do

  let(:user) { create(:user) }
  let!(:question) { create(:question) }


  describe 'Authenticated user' do
    before { sign_in user }

    scenario 'sees link to edit his question' do
      question.update(user: user)
      visit question_path(question)

      within '.question' do
        expect(page).to have_link 'Edit question'           #TODO
      end
    end

    scenario 'does not see link to edit not his question' do
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'Edit question'       #TODO
      end
    end

    scenario 'try to edit his question', js: true do
      question.update(user: user)
      visit question_path(question)
      within '.question' do
        click_on 'Edit question'
        fill_in 'Title', with: 'edited question title'
        fill_in 'Body', with: 'edited question body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question title'
        expect(page).to have_content 'edited question body'
        expect(page).to_not have_selector 'textfield'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end


  scenario "Non-authenticated user try to edit question" do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit question'       #TODO
    end
  end

end