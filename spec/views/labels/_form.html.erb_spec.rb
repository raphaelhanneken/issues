require 'rails_helper'

RSpec.describe 'labels/_form', type: :view do
  let(:report) { FactoryGirl.build_stubbed(:report) }
  let(:label)  { Label.new }

  before(:each) do
    assign(:report, report)
    assign(:label, label)
    render
  end

  it 'renders all necessary fields' do
    expect(rendered).to have_form(report_labels_path(report, label), 'post') do
      with_text_field 'label[title]'
      with_text_field 'label[color]'

      with_submit 'Create Label'
    end
  end
end
