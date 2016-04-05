require 'rails_helper'

RSpec.describe "users/_password_form", type: :view do
  let!(:user) { FactoryGirl.build_stubbed(:user) }

  before(:each) do
    assign(:user, user)
    render
  end

  it 'renders a password form' do
    expect(rendered).to have_form(update_password_user_path(user), 'post') do
      with_password_field 'user[current_password]'
      with_password_field 'user[password]'
      with_password_field 'user[password_confirmation]'

      with_submit 'Update Password'
    end
  end
end
