require 'rails_helper'

RSpec.describe 'shared/_sidenavigation', type: :view do
  context 'users navigation' do
    let(:user) { FactoryGirl.build_stubbed(:user) }

    before(:each) do
      allow(controller).to receive(:controller_name).and_return('users')
      assign(:user, user)
      render
    end

    it 'displays the user e-mail' do
      expect(rendered).to have_content user.email
    end
  end

  context 'reports navigation' do
    before(:each) do
      render
    end

    it 'displays an inbox link' do
      expect(rendered).to have_link('Inbox', href: root_path)
    end

    it 'displays an assigned_to_you link' do
      expect(rendered).to have_link('Assigned to You', href: assigned_to_you_reports_path)
    end

    it 'displays an reported_by_you link' do
      expect(rendered).to have_link('Reported by You', href: reported_by_you_reports_path)
    end

    it 'display an unassigned link' do
      expect(rendered).to have_link('Unassigned', href: unassigned_reports_path)
    end

    it 'displays a open link' do
      expect(rendered).to have_link('Open', href: open_reports_path)
    end

    it 'displays a closed link' do
      expect(rendered).to have_link('Closed', href: closed_reports_path)
    end

    it 'displays an all link' do
      expect(rendered).to have_link('All', href: reports_path)
    end
  end
end
