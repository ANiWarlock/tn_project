require_relative '../feature_helper'

feature 'Add files to question', %q{
  In order to illustrate question
  As an author of question
  I want to be able to attach files to question
} do

  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  before do
    sign_in user
  end

  scenario 'Question author adds multiple files when create question', js: true do
    visit new_question_path
    fill_in 'Title', with: 'Some title'
    fill_in 'Body', with: 'Some body'

    click_on "add attachments"
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    click_on "add attachments"
    within page.all("div.nested-fields")[1] do
     attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Create'

    expect(page).to have_content 'spec_helper.rb'
    expect(page).to have_content 'rails_helper.rb'
  end

  scenario 'Question author adds multiple files to existing question', js: true do
    visit question_path(question)
    click_on 'Edit question'
    within '.edit_question' do
      click_on "add attachments"
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

      click_on "add attachments"
      within page.all("div.nested-fields")[1] do
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      end

      click_on 'Save'
    end

    expect(page).to have_content 'spec_helper.rb'
    expect(page).to have_content 'rails_helper.rb'
  end
end