require 'rails_helper'

RSpec.describe "users/new", type: :view do
  before(:each) do
    assign(:user, User.new)
    render
  end

  it 'renders the _form paritial' do
    expect(response).to render_template(partial: '_form')
  end

  it 'displays a create button' do
    expect(response).to have_tag('input[type=submit]', value: 'Create User')
  end
end
