# == Schema Information
#
# Table name: reports
#
#  id          :integer          not null, primary key
#  title       :string           not null
#  description :text             not null
#  project_id  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  reporter_id :integer
#  assignee_id :integer
#  closed      :boolean
#

require 'rails_helper'

RSpec.describe ReportsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/reports').to route_to('reports#index')
    end

    it 'routes reports/inbox to #index' do
      expect(get: '/reports/inbox').to route_to('reports#index', filter: 'inbox')
    end

    it 'routes reports/assigned_to_you to #index' do
      expect(get: '/reports/assigned_to_you').to route_to('reports#index', filter: 'assigned_to_you')
    end

    it 'routes reports/reported_by_you to #index' do
      expect(get: '/reports/reported_by_you').to route_to('reports#index', filter: 'reported_by_you')
    end

    it 'routes reports/unassigned to #index' do
      expect(get: '/reports/unassigned').to route_to('reports#index', filter: 'unassigned')
    end

    it 'routes reports/open' do
      expect(get: '/reports/open').to route_to('reports#index', filter: 'open')
    end

    it 'routes reports/closed' do
      expect(get: '/reports/closed').to route_to('reports#index', filter: 'closed')
    end

    it 'routes to #new' do
      expect(get: '/reports/new').to route_to('reports#new')
    end

    it 'routes to #show' do
      expect(get: '/reports/1').to route_to('reports#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/reports/1/edit').to route_to('reports#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/reports').to route_to('reports#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/reports/1').to route_to('reports#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/reports/1').to route_to('reports#update', id: '1')
    end

    it 'routes not to #destroy' do
      expect(delete: '/reports/1').not_to route_to('reports#destroy', id: '1')
    end

    it 'routes to #assign_to_me via PUT' do
      expect(put: '/reports/1/assign_to_me').to route_to('reports#assign_to_me', id: '1')
    end

    it 'routes to #close' do
      expect(put: 'reports/1/close').to route_to('reports#close', id: '1')
    end

    it 'routes to #open' do
      expect(put: 'reports/1/open').to route_to('reports#open', id: '1')
    end

    it 'routes to #edit_assignee' do
      expect(get: 'reports/1/edit_assignee').to route_to('reports#edit_assignee', id: '1')
    end

    it 'routes to #update_assignee' do
      expect(put: 'reports/1/update_assignee').to route_to('reports#update_assignee', id: '1')
    end

    it 'routes to #edit_labels' do
      expect(get: 'reports/1/edit_labels').to route_to('reports#edit_labels', id: '1')
    end

    it 'routes to #add_label' do
      expect(put: 'reports/1/add_label/3').to route_to('reports#add_label', id: '1', label_id: '3')
    end

    it 'routes to #remove_label' do
      expect(put: 'reports/1/remove_label/4').to route_to('reports#remove_label', id: '1', label_id: '4')
    end
  end
end
