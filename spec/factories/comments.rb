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

FactoryGirl.define do
  factory :comment, class: :comment do
    content     { Faker::Lorem.sentence }
    association :user,   factory: :user
    association :report, factory: :report
  end
end
