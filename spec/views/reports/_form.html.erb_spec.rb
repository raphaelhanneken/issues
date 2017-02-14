require 'rails_helper'

RSpec.describe 'reports/_form', type: :view do
  context 'on update' do
    let(:report) { FactoryGirl.build_stubbed(:report) }

    before(:each) do
      assign(:report, report)
      render
    end

    it 'renders a prefilled report form' do
      expect(rendered).to have_form(report_path(report), 'post') do
        with_text_field   'report[title]', report.title
        with_text_area    'report[description]' # value: not working yet.
        with_select       'report[project_id]', selected: report.project.id

        with_submit 'Update Report'
      end
    end
  end

  context 'on create' do
    before(:each) do
      assign(:report, Report.new)
      render
    end

    it 'renders the report form' do
      expect(rendered).to have_form(reports_path, 'post') do
        with_text_field   'report[title]'
        with_text_area    'report[description]'
        with_select       'report[project_id]'

        with_submit 'Create Report'
      end
    end
  end
end
