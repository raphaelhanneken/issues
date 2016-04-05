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

FactoryGirl.define do
  factory :label, class: :label do
    title   { Faker::Lorem.word }
    color   { "##{ Faker::Number.hexadecimal(6) }" }
  end
end
