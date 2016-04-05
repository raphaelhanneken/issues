require 'rails_helper'

RSpec.describe 'projects/edit', type: :view do
  let(:project) { FactoryGirl.build(:project) }
  
  before(:each) do
    assign(:project, project)
    render
  end
  
  it 'displays a header' do
    expect(rendered).to match("Edit #{project.name}")
  end

  it 'renders the form partial' do
    expect(response).to render_template(partial: '_form')
  end

  it 'has a submit button' do
    expect(rendered).to have_tag('input', value: 'Update Project')
  end
end
