require 'rails_helper'

RSpec.describe 'projects/new', type: :view do
  before(:each) do
    assign(:project, Project.new)
    render
  end

  it 'displays a header' do
    expect(rendered).to match('New Project')
  end

  it 'renders the form partial' do
    expect(response).to render_template(partial: '_form')
  end

  it 'has a submit button' do
    expect(rendered).to have_tag('input', value: 'Create Project')
  end
end
