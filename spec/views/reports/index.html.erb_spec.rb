require 'rails_helper'

RSpec.describe "reports/index", type: :view do
  before(:each) do
    assign(:reports, [
      FactoryGirl.build_stubbed(:report, title: 'Test Project 01', description: 'Lorem ipsum', created_at: Date.today - 5.days),
      FactoryGirl.build_stubbed(:report, title: 'Test Project 02', description: 'Lorem ipsum', created_at: Date.today - 7.days)
    ])
    render
  end

  it 'renders the report partial for each report' do
    expect(rendered).to render_template(partial: '_report', count: 2)
  end

  it 'displays each report title' do
    expect(rendered).to match(/Test Project 01/)
    expect(rendered).to match(/Test Project 02/)
  end

  it 'displays time ago in words for the creation date' do
    expect(rendered).to match(/[5-6] days ago/)
    expect(rendered).to match(/[7-8] days ago/)
  end

  it 'displays a shortened description' do
    expect(rendered).to match(/Lorem ipsum/)
  end
end
