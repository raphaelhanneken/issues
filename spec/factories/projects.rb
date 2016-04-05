# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  version    :string           default("")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'faker'

FactoryGirl.define do
  factory :project, class: :project do
    name        { Faker::App.name }
    version     { Faker::App.version }

    factory :project_with_reports, class: :project do
      after(:create) do |project|
        create(:report, project: project)
        create(:report, project: project)
        create(:report, project: project)
      end
    end
  end
end
