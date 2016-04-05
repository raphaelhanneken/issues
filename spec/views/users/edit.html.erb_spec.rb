require 'rails_helper'

RSpec.describe "users/edit", type: :view do
  before(:each) do
    assign(:user, FactoryGirl.build_stubbed(:user))
    render
  end

  it 'renders the _form partial' do
    expect(response).to render_template(partial: '_form')
  end

  it 'displays an update button' do
    expect(response).to have_tag('input[type=submit]', value: 'Update User')
  end
end
