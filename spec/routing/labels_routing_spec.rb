# == Schema Information
#
# Table name: labels
#
#  id         :integer          not null, primary key
#  title      :string
#  color      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe LabelsController, type: :routing do
  describe 'routing' do
    it 'does not route to #index' do
      expect(get: '/reports/2/labels').not_to route_to('labels#index', report_id: 2)
    end

    it 'routes to #show' do
      expect(get: '/labels/1').to route_to('labels#show', id: '1')
    end

    it 'does not route to #edit' do
      expect(get: '/labels/3/edit').not_to route_to('labels#edit', id: '3')
    end

    it 'does not route to #update via put' do
      expect(put: '/labels/2').not_to route_to('labels#update', id: '2')
    end

    it 'does not route to #update via patch' do
      expect(patch: '/labels/3').not_to route_to('labels#update', id: '3')
    end

    it 'routes to #new' do
      expect(get: '/reports/1/labels/new').to route_to('labels#new', report_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/reports/2/labels/').to route_to('labels#create', report_id: '2')
    end

    it 'routes to #destroy' do
      expect(delete: '/labels/3').to route_to('labels#destroy', id: '3')
    end
  end
end
