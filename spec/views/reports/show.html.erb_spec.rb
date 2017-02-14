require 'rails_helper'

RSpec.describe 'reports/show', type: :view do
  let(:comment) { FactoryGirl.build_stubbed(:user).comments.new }
  let(:report) { FactoryGirl.build_stubbed(:report) }
  let(:report_closed) { FactoryGirl.build_stubbed(:report, closed: true) }
  let(:report_unassigned) { FactoryGirl.build_stubbed(:report, assignee: nil) }

  before(:each) do
    assign(:report, report)
    assign(:comment, comment)
    render
  end

  it 'displays the report title' do
    expect(rendered).to have_content(report.title)
  end

  it 'displays the report id' do
    expect(rendered).to have_content('#' + report.id.to_s)
  end

  it 'displays the report description' do
    expect(rendered).to have_content(report.description)
  end

  it 'displays the current labels' do
    expect(rendered).to have_content(report.labels.first.title)
  end

  it 'displays a link to the reporter' do
    expect(rendered).to have_link(report.reporter.name, href: user_path(report.reporter))
  end

  it 'displays the associated project name as link' do
    expect(rendered).to have_link(report.project.name, href: project_path(report.project))
  end

  it 'does not display an edit link' do
    expect(rendered).not_to have_link('Edit')
  end

  it 'displays a link to the assignees profile' do
    expect(rendered).to have_link(report.assignee.name, href: user_path(report.assignee))
  end

  it 'does not display an edit assignee link' do
    expect(rendered).not_to have_link(report.assignee.name, href: edit_assignee_report_path(report))
  end

  it 'does not display an edit labels link' do
    expect(rendered).not_to have_link('Edit Labels', href: edit_labels_report_path(report))
  end

  it 'displays the current status' do
    expect(response).to have_content('Open')
  end

  it 'renders a comment form' do
    expect(rendered).to render_template('comments/_form')
  end

  context 'for an unassigned report' do
    before(:each) do
      allow(view).to receive(:current_user).and_return(FactoryGirl.build_stubbed(:user))
      assign(:report, report_unassigned)
      render
    end

    it 'displays an assign to me link' do
      expect(rendered).to have_link 'Assign to me', href: assign_to_me_report_path(report_unassigned)
    end
  end

  describe 'as the reporter' do
    before(:each) do
      allow(view).to receive(:current_user).and_return(report.reporter)
      render
    end

    it 'displays an edit link' do
      expect(response).to have_link('Edit', href: edit_report_path(report))
    end

    it 'displays an update assignee link' do
      expect(response).to have_link(report.assignee.name.to_s, href: edit_assignee_report_path(report))
    end

    it 'displays an edit labels link' do
      expect(rendered).to have_link('Edit Labels', href: edit_labels_report_path(report))
    end

    context 'for an open report' do
      it 'displays a close link' do
        expect(rendered).to have_link('Close', href: close_report_path(report))
      end
    end

    context 'for a closed report' do
      before(:each) do
        allow(view).to receive(:current_user).and_return(report_closed.reporter)
        assign(:report, report_closed)
        render
      end

      it 'displays an open link' do
        expect(rendered).to have_link('Reopen', href: open_report_path(report_closed))
      end
    end
  end

  describe 'as the assignee' do
    before(:each) do
      allow(view).to receive(:current_user).and_return(report.assignee)
      render
    end

    it 'displays no edit link' do
      expect(response).not_to have_link('Edit', href: edit_report_path(report))
    end

    it 'displays an update assignee link' do
      expect(response).to have_link(report.assignee.name.to_s, href: edit_assignee_report_path(report))
    end

    it 'displays an edit labels link' do
      expect(rendered).to have_link('Edit Labels', href: edit_labels_report_path(report))
    end

    context 'for an open report' do
      it 'displays a close link' do
        expect(rendered).to have_link('Close', href: close_report_path(report))
      end
    end

    context 'for a closed report' do
      before(:each) do
        allow(view).to receive(:current_user).and_return(report_closed.assignee)
        assign(:report, report_closed)
        render
      end

      it 'displays an open link' do
        expect(rendered).to have_link('Reopen', href: open_report_path(report_closed))
      end
    end
  end
end
