require 'rails_helper'

RSpec.describe "projects/index", type: :view do
  before(:each) do
    assign(:projects, [
      FactoryGirl.build(:project, name: 'Test Project 01'),
      FactoryGirl.build(:project, name: 'Test Project 02')
    ])
    render
  end

  it "renders the project partial for each project" do
    expect(rendered).to render_template(partial: '_project', count: 2)
  end

  it "displays the project names" do
    expect(rendered).to have_content('Test Project 01')
    expect(rendered).to have_content('Test Project 02')
  end
end
