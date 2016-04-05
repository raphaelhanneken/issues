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

require 'faker'

FactoryGirl.define do
  factory :report, class: :report do
    title       { Faker::Lorem.sentence(2) }
    description { Faker::Lorem.paragraph(2) }
    association :project,  factory: :project
    association :assignee, factory: :user
    association :reporter, factory: :user
    labels      { [create(:label), create(:label)] }

    factory :report_with_comments, class: :report do
      after(:create) do |report|
        create(:comment, report: report)
        create(:comment, report: report)
        create(:comment, report: report)
      end
    end
  end
end
