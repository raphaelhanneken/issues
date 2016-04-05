require 'rails_helper'

RSpec.describe 'reports/_assignee_form', type: :view do
  let(:report) { FactoryGirl.build_stubbed(:report) }
  let(:user)   { FactoryGirl.build_stubbed(:user) }

  before(:each) do
    assign(:report, report)
    render
  end

  it 'renders the correct form' do
    expect(rendered).to have_tag('form', with: { action: update_assignee_report_path(report), method: 'post' })
  end

  it 'renders the assignees' do
    expect(rendered).to have_tag('input', with: { type: 'submit', value: 'Assign' })
  end
end
