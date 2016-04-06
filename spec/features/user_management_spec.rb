require 'rails_helper'

include Warden::Test::Helpers
Warden.test_mode!

RSpec.describe "Managing Users", type: :feature do
  let!(:user)   { FactoryGirl.create(:user) }
  let!(:report) { FactoryGirl.create(:report) }
  let!(:admin)  { FactoryGirl.create(:user, admin: true) }

  scenario 'signing in' do
    visit report_url(report)
    within 'form#new_user' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Login'
    end
    expect(page).to have_current_path(report_path(report))
    expect(page).to have_content('success')
  end

  scenario 'signing up' do
    visit new_user_session_url
    click_on 'Register'

    within 'form#new_user' do
      fill_in 'Email', with: 'axl.rose@gunsnroses.com'
      fill_in 'Firstname', with: 'Axl'
      fill_in 'Lastname', with: 'Rose'
      fill_in 'user_password', with: 'Guns \'n\' Roses'
      fill_in 'user_password_confirmation', with: 'Guns \'n\' Roses'

      click_on 'Sign up'
    end
    expect(page).to have_current_path(root_path)
    expect(page).to have_content('Welcome!')
  end

  describe 'editing' do
    before(:each) do
      login_as(user, scope: :user)
      visit user_path(user)
      click_on 'Edit'
    end

    scenario 'profiles' do
      within 'form.edit_user' do
        fill_in 'Firstname', with: 'Anthony'
        fill_in 'Lastname', with: 'Kiedis'
        click_on 'Update'
      end
      expect(page).to have_current_path(user_path(user))
      expect(page).to have_content('Anthony Kiedis')
    end

    scenario 'passwords', js: true do
      click_on 'Change Password'
      within 'form#edit_password' do
        fill_in 'user_current_password', with: user.password
        fill_in 'user_password', with: 'New Password'
        fill_in 'user_password_confirmation', with: 'New Password'
        click_on 'Update'
      end
      expect(page).to have_current_path(user_path(user))
      expect(page).to have_content('updated.')
    end
  end

  describe 'deleting an account' do
    scenario 'as current user' do
      login_as(user, scope: :user)
      visit user_path(user)
      click_on 'Delete'
      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content('deleted.')
    end

    scenario 'as admin' do
      login_as(admin, scope: :user)
      visit users_path
      click_on 'Delete', match: :first
      expect(page).to have_current_path(users_path)
      expect(page).to have_content('deleted.')
    end
  end
end
