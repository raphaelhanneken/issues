require 'rails_helper'

RSpec.describe "projects/show", type: :view do
  let(:project) { FactoryGirl.build_stubbed(:project) }

  before(:each) do
    assign(:project, project)
    allow(view).to receive(:current_user).and_return(FactoryGirl.build_stubbed(:user, admin: false))
    render
  end

  it "displays the project name" do
    expect(response).to have_content(project.name)
  end

  it 'displays the version number' do
    expect(response).to have_content(project.version)
  end

  it 'does not display an edit link' do
    expect(response).not_to have_link('Edit', href: edit_project_path(project))
  end

  it 'does not display a delete link' do
    expect(response).not_to have_link('Delete', href: project_path(project))
  end

  it 'displays the associated reports' do
    project.reports.each do |report|
      expect(rendered).to have_content report.title
    end
  end

  context 'as admin user' do
    before(:each) do
      allow(view).to receive(:current_user).and_return(FactoryGirl.build_stubbed(:user, admin: true))
      render
    end

    it 'displays an edit link' do
      expect(response).to have_link('Edit', href: edit_project_path(project))
    end

    it 'displays a delete link' do
      expect(response).to have_link('Delete', href: project_path(project))
    end
  end
end
