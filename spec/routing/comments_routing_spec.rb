# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  content    :text
#  user_id    :integer
#  report_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe CommentsController, type: :routing do
  before(:each) do
    FactoryGirl.create(:report)
  end

  it 'routes to #create via post' do
    expect(post: 'reports/1/comments').to route_to('comments#create', report_id: '1')
  end

  it 'routes to #create via put' do
    expect(post: 'reports/1/comments').to route_to('comments#create', report_id: '1')
  end

  it 'routes not to #index' do
    expect(get: 'reports/1/comments').not_to route_to('comments#index')
  end

  it 'routes not to #new' do
    expect(get: 'reports/1/comments/new').not_to route_to('comments#new')
  end

  it 'routes not to #show' do
    expect(get: 'comments/1').not_to route_to('comments#show', id: '1')
  end

  it 'routes not to #destroy' do
    expect(delete: 'comments/1').not_to route_to('comments#destroy', id: '1')
  end

  it 'routes not to #edit' do
    expect(get: 'comments/1/edit').not_to route_to('comments#edit', id: '1')
  end

  it 'routes not to #update via put' do
    expect(put: 'comments/1').not_to route_to('comments#update', id: '1')
  end

  it 'routes not to #update via patch' do
    expect(patch: 'comments/1').not_to route_to('comments#update', id: '1')
  end
end
