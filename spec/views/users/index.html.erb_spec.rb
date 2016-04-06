require 'rails_helper'

RSpec.describe "users/index", type: :view do
  let(:user_01) { FactoryGirl.build_stubbed(:user, firstname: 'Robert', lastname: 'Plant') }
  let(:user_02) { FactoryGirl.build_stubbed(:user, firstname: 'Jimmy', lastname: 'Page') }

  before(:each) do
    allow(view).to receive(:current_user).and_return(FactoryGirl.build_stubbed(:user))
    assign(:users, [user_01, user_02])
    render
  end

  it 'renders the user partial for each user' do
    expect(response).to render_template(partial: '_user', count: 2)
  end

  it 'displays a link to each user' do
    expect(response).to have_link('Robert Plant', href: user_path(user_01))
    expect(response).to have_link('Jimmy Page', href: user_path(user_02))
  end

  it 'does not display delete links' do
    expect(response).not_to have_link('Delete')
  end

  describe 'for users with admin privileges' do
    before(:each) do
      allow(view).to receive(:current_user).and_return(FactoryGirl.build_stubbed(:user, admin: true))
      render
    end

    it 'displays a delete link for each user' do
      expect(response).to have_link('Delete', href: user_path(user_01))
      expect(response).to have_link('Delete', href: user_path(user_02))
    end
  end
end
