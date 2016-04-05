require 'rails_helper'

RSpec.describe 'labels/show', type: :view do
  let(:labels) { [FactoryGirl.build_stubbed(:label), FactoryGirl.build_stubbed(:label)] }
  let(:report) { FactoryGirl.build_stubbed(:report, labels: labels) }

  before(:each) do
    assign(:label, labels.first)
    allow(view).to receive(:current_user).and_return(FactoryGirl.build_stubbed(:user, admin: false))
    render
  end

  it 'renders the associated reports' do
    labels.first.reports.each do |report|
      expect(rendered).to have_content report.title
    end
  end

  it 'renders the current label name' do
    expect(rendered).to have_content labels.first.title
  end

  it 'does not show action buttons' do
    expect(rendered).not_to have_link 'Delete Label', href: label_path(labels.first)
  end

  context 'as admin user' do
    before(:each) do
      allow(view).to receive(:current_user).and_return(FactoryGirl.build_stubbed(:user, admin: true))
      render
    end

    it 'displays action buttons' do
      expect(rendered).to have_link 'Delete Label', href: label_path(labels.first)
    end
  end
end
