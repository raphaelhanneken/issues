require 'rails_helper'

RSpec.describe 'projects/_form', type: :view do
  context 'on update' do
    let(:project) { FactoryGirl.build_stubbed(:project) }

    before(:each) do
      assign(:project, project)
      render
    end

    it 'renders a prefilled project form' do
      expect(rendered).to have_form(project_path(project), 'post') do
        with_text_field 'project[name]', project.name
        with_text_field 'project[version]', project.version
        with_submit     'Update Project'
      end
    end
  end

  context 'on create' do
    before(:each) do
      assign(:project, Project.new)
      render
    end

    it 'renders the required form fields' do
      expect(rendered).to have_form(projects_path, 'post') do
        with_text_field 'project[name]'
        with_text_field 'project[version]'
        with_submit     'Create Project'
      end
    end
  end
end
