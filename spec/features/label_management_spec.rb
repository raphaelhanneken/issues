require 'rails_helper'

RSpec.describe "Managing Labels", type: :feature do
  let!(:user)   { FactoryGirl.create(:user, admin: true) }
  let!(:label)  { FactoryGirl.create(:label) }
  let!(:report) { FactoryGirl.create(:report, reporter: user) }

  before(:each) do
    login_as user, scope: :user
  end

  scenario 'Deleting a label' do
    visit label_url(label)
    click_on 'Delete'
    expect(page).to have_current_path root_path
    expect(page).to have_content 'Label deleted.'
  end

  scenario 'Creating a label', js: true do
    visit report_path(report)
    click_on 'Edit Labels'
    wait_for_ajax
    click_on 'New Label'
    wait_for_ajax
    within '#new_label' do
      fill_in 'Title', with: 'A Label'
      fill_in 'Color', with: '#90A959'
    end
    click_on 'Create'
    expect(page).to have_current_path report_path(report)
    expect(page).to have_content 'New label added.'
  end
end
