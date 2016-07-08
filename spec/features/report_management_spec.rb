require 'rails_helper'

RSpec.describe "Managing Reports", type: :feature do
  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    login_as(user, scope: :user)
  end

  describe 'Creating a new report', js: true do
    let!(:assignee) { FactoryGirl.create(:user, firstname: 'Hugh') }
    let!(:project)  { FactoryGirl.create(:project) }

    before(:each) do
      visit reports_path
      click_on 'new-report'
      wait_for_ajax
    end

    scenario 'with valid data' do
      within 'form#new_report' do
        fill_in 'report_title', with: 'A Title'
        fill_in 'report_description', with: 'Hello World! This is a description.'

        click_on 'Create'
      end
      wait_for_ajax
      expect(page).to have_content('Report created.')
      expect(page).to have_current_path('/reports/1')
    end

    scenario 'with invalid data' do
      within 'form#new_report' do
        fill_in 'Title', with: '   '
        fill_in 'Description', with: 'Hello World! This is a description.'

        click_on 'Create'
      end
      wait_for_ajax
      expect(page).to have_content('can\'t be blank')
      expect(page).to have_current_path('/reports')
    end
  end

  describe 'Updating an existing report' do
    let!(:report) { FactoryGirl.create(:report, reporter: user) }

    before(:each) do
      visit report_path(report)
      click_on 'Edit'
    end

    scenario 'with valid data' do
      within 'form.edit_report' do
        fill_in  'report_title', with: 'A new title'
        click_on 'Update'
      end
      expect(page).to have_content('updated')
      expect(page).to have_current_path(report_path(report))
    end

    scenario 'with invalid data' do
      within 'form.edit_report' do
        fill_in  'report_title', with: '  '
        click_on 'Update'
      end
      expect(page).to have_content('can\'t be blank')
      expect(page).to have_current_path(report_path(report))
    end
  end

  describe 'Updating the report status' do
    let!(:report)        { FactoryGirl.create(:report, reporter: user ) }
    let!(:report_closed) { FactoryGirl.create(:report, closed: true, reporter: user) }

    scenario 'closing an open report' do
      visit report_path(report)
      click_on 'Close'
      expect(page).to have_content('Report closed.')
      expect(page).to have_current_path(report_path(report))
    end

    scenario 'opening a closed report' do
      visit report_path(report_closed)
      click_on 'Reopen'
      expect(page).to have_content('Report opened.')
      expect(page).to have_current_path(report_path(report_closed))
    end
  end

  describe 'Edit assignee', js: true do
    let!(:assignee)          { FactoryGirl.create(:user) }
    let!(:report)            { FactoryGirl.create(:report, reporter: user) }
    let!(:unassigned_report) { FactoryGirl.create(:report, reporter: user, assignee: nil) }

    scenario 'for an already assigned report' do
      visit report_path(report)
      click_link 'edit-assignee'
      wait_for_ajax
      choose "#{assignee.name}"
      click_on 'Assign'
      wait_for_ajax
      expect(page).to have_content('Assignee updated.')
      expect(page).to have_current_path(report_path(report))
    end

    scenario 'for an unassigned report' do
      visit report_path(unassigned_report)
      click_link 'Add'
      wait_for_ajax
      choose "#{assignee.name}"
      click_on 'Assign'
      expect(page).to have_content('Assignee updated.')
      expect(page).to have_current_path(report_path(unassigned_report))
    end
  end

  describe 'Editing labels', js: true do
    let!(:report) { FactoryGirl.create(:report, reporter: user) }
    let!(:label)  { FactoryGirl.create(:label) }

    scenario 'adding a label' do
      visit report_path(report)
      within '#report-labels' do
        expect(page).not_to have_link label.title
      end
      click_on 'Edit Labels'
      wait_for_ajax
      within '#edit-labels' do
        click_link "label-#{label.id}"
      end
      wait_for_ajax
      expect(page).to have_content 'Label added.'
      click_on 'Done'
      within '#report-labels' do
        expect(page).to have_link label.title
      end
    end

    scenario 'removing a label' do
      label = report.labels.first
      visit report_path(report)
      within '#report-labels' do
        expect(page).to have_link label.title
      end
      click_on 'Edit Labels'
      wait_for_ajax
      within '#edit-labels' do
        click_link "label-#{label.id}"
      end
      wait_for_ajax
      expect(page).to have_content 'Label removed.'
      click_on 'Done'
      within '#report-labels' do
        expect(page).not_to have_content label.title
      end
    end
  end

  describe 'Commenting' do
    let!(:report) { FactoryGirl.create(:report) }

    scenario 'posting a new comment' do
      visit report_path(report)
      within '#new_comment' do
        fill_in  'comment_content', with: 'Hello World!'
        click_on 'Comment'
      end
      expect(page).to have_current_path(report_path(report))
      expect(page).to have_content 'Comment created.'
      expect(page).to have_content 'Hello World!'
    end
  end
end
