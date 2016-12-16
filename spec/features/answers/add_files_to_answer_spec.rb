require_relative '../feature_helper'

feature 'Add files to answer', %q{
  In order to illustrate answer
  As an author of answer
  I want to be able to attach files to answer
} do

  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  before do
    sign_in user
  end

  scenario 'Answer author adds multiple files when create answer', js: true do
    visit question_path(question)
    fill_in 'Body', with: 'Some body'

    click_on "add attachments"
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    click_on "add attachments"
    within page.all("div.nested-fields")[1] do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Give answer'

    expect(page).to have_content 'spec_helper.rb'
    expect(page).to have_content 'rails_helper.rb'
  end

  scenario 'Answer author adds multiple files to existing answer', js: true do
    visit question_path(question)
    fill_in 'Body', with: 'Some body'
    click_on 'Give answer'

    within '.answers' do
      click_on 'Edit answer'
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