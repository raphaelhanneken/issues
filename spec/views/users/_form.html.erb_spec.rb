require 'rails_helper'

RSpec.describe 'users/_form', type: :view do
  context 'on update' do
    let!(:user) { FactoryGirl.build_stubbed(:user) }

    before(:each) do
      assign(:user, user)
      render
    end

    it 'renders a prefilled user form' do
      expect(rendered).to have_form(user_path(user), 'post') do
        with_email_field 'user[email]',     user.email
        with_text_field  'user[firstname]', user.firstname
        with_text_field  'user[lastname]',  user.lastname

        with_submit      'Update User'
      end
    end
  end

  context 'on create' do
    before(:each) do
      assign(:user, User.new)
      render
    end

    it 'renders the empty user form' do
      expect(rendered).to have_form(users_path, 'post') do
        with_email_field 'user[email]'
        with_text_field  'user[firstname]'
        with_text_field  'user[lastname]'

        with_submit      'Create User'
      end
    end
  end
end
