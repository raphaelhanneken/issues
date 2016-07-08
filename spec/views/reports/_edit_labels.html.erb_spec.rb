require 'rails_helper'

RSpec.describe 'reports/_edit_labels', type: :view do
  let!(:labels) { [FactoryGirl.build_stubbed(:label), FactoryGirl.build_stubbed(:label), FactoryGirl.build_stubbed(:label)]}
  let!(:report) { FactoryGirl.build_stubbed(:report, labels: [labels.first, labels.last]) }

  before(:each) do
    assign(:labels, labels)
    assign(:report, report)
    render
  end

  it 'displays a new label button' do
    expect(rendered).to have_link('New Label', href: new_report_label_path(report))
  end

  it 'displays a done button' do
    expect(rendered).to have_link 'Done'
  end

  it 'renders the available labels' do
    expect(rendered).to have_link(labels.second.title, href: add_label_to_report_path(report, labels.second))
    expect(rendered).to have_link(labels.first.title,  href: remove_label_from_report_path(report, labels.first))
    expect(rendered).to have_link(labels.last.title,   href: remove_label_from_report_path(report, labels.last))
  end
end
