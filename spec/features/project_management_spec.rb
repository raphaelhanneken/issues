require 'rails_helper'

RSpec.describe "Managing Projects", type: :feature do
  let!(:user) { FactoryGirl.create(:user, admin: true) }

  before(:each) do
    login_as(user, scope: :user)
  end
  
  describe 'Creating a new project' do
    before(:each) do
      visit new_project_url
    end
    
    scenario 'with valid data' do
      within 'form#new_project' do
        fill_in 'Name', with: 'A new Project'
        click_on 'Create'
      end
      expect(page).to have_content('created')
      expect(page).to have_current_path('/projects/1')
    end

    scenario 'with invalid data' do
      within 'form#new_project' do
        fill_in 'Name', with: '   '
        click_on 'Create'
      end
      expect(page).to have_content('can\'t be blank')
      expect(page).to have_current_path('/projects')
    end
  end

  describe 'Updating an existing project' do
    let(:project) { FactoryGirl.create(:project) }
    
    before(:each) do
      visit edit_project_url(project)
    end

    scenario 'with valid data' do
      within 'form#edit_project_1' do
        fill_in 'Name', with: 'New Project Name'
        click_on 'Update'
      end
      expect(page).to have_content('updated')
      expect(page).to have_current_path('/projects/1')
    end

    scenario 'with invalid data' do
      within 'form#edit_project_1' do
        fill_in 'Name', with: '  '
        click_on 'Update'
      end
      expect(page).to have_content('can\'t be blank')
      expect(page).to have_current_path('/projects/1')
    end
  end

  scenario 'Deleting a project' do
    project = FactoryGirl.create(:project)
    visit project_path(project)
    click_on 'Delete'
    expect(page).to have_content('deleted')
    expect(page).to have_current_path('/projects')
  end
end
