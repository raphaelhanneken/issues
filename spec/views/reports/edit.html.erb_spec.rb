require 'rails_helper'

RSpec.describe 'reports/edit', type: :view do
  let(:report) { FactoryGirl.build_stubbed(:report) }
  
  before(:each) do
    assign(:report, report)
    render
  end

  it 'renders the _form partial' do
    expect(response).to render_template(partial: '_form')
  end
  
  it 'displays a header' do
    expect(rendered).to match('Edit Report')
  end

  it 'displays an update button' do
    expect(rendered).to have_tag('input', value: 'Update Report')
  end
end
