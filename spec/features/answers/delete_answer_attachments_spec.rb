require_relative '../feature_helper'

feature 'Delete attached files', %q{
  In order to delete useless attachments
  As an answer author
  I want to be able to delete attached files
} do

  let!(:user){ create(:user) }
  let(:question){ create(:question, user: user) }

  before js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'some body text'
    within '.new_answer' do
      click_on "add attachments"
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Give answer'
    end
  end

  scenario 'Answer author tries to delete attachment', js: true do
    within '.attachments' do
      click_on 'delete'
      expect(page).to_not have_content "spec_helper.rb"
    end
  end
end