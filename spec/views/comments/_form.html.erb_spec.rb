require 'rails_helper'

RSpec.describe 'comments/_form', type: :view do
  let(:report)  { FactoryGirl.build_stubbed(:report) }
  let(:comment) { FactoryGirl.build_stubbed(:user).comments.new }

  before(:each) do
    assign(:report, report)
    assign(:comment, comment)
    render
  end

  it 'renders a new comment form' do
    expect(rendered).to have_form(report_comments_path(report, comment), 'post') do
      with_text_area 'comment[content]'
      with_submit 'Comment'
    end
  end
end
