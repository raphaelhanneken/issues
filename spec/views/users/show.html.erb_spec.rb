require 'rails_helper'

RSpec.describe "users/show", type: :view do
  let(:user) { FactoryGirl.build_stubbed(:user) }

  before(:each) do
    assign(:user, user)
    render
  end

  it 'displays the firstname' do
    expect(rendered).to have_content user.firstname
  end

  it 'displays the lastname' do
    expect(rendered).to have_content user.lastname
  end

  it 'does not display a delete link' do
    expect(rendered).not_to have_link 'Delete'
  end

  it 'does not display an edit link' do
    expect(rendered).not_to have_link 'Edit'
  end

  describe 'as correct user' do
    before(:each) do
      allow(view).to receive(:current_user).and_return(user)
      render
    end

    it 'displays a delete link' do
      expect(rendered).to have_link('Delete', href: user_path(user))
    end

    it 'displays an edit link' do
      expect(rendered).to have_link('Edit', href: edit_user_path(user))
    end
  end
end
