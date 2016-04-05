require 'rails_helper'

RSpec.describe 'reports/new', type: :view do
  before(:each) do
    assign(:report, Report.new)
    render
  end

  it 'displays a header' do
    expect(rendered).to match('New Report')
  end
  
  it 'renders the _form partial' do
    expect(response).to render_template(partial: '_form')
  end

  it 'has a create button' do
    expect(rendered).to have_tag('input', value: 'Create Report')
  end
end
