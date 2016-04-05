# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  firstname              :string           not null
#  lastname               :string           not null
#  admin                  :boolean          default(FALSE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#

require 'faker'

FactoryGirl.define do
  factory :user, class: :user do
    email     { Faker::Internet.email }
    password  { Faker::Internet.password(8) }
    firstname { Faker::Name.first_name }
    lastname  { Faker::Name.last_name }

    factory :reporter, class: :user do
      after(:create) do |usr|
        create(:report, reporter: usr)
        create(:report, reporter: usr)
        create(:report, reporter: usr)
      end
    end

    factory :assignee, class: :user do
      after(:create) do |usr|
        create(:report, assignee: usr)
        create(:report, assignee: usr)
        create(:report, assignee: usr)
      end
    end

    factory :commenter, class: :user do
      after(:create) do |usr|
        create(:comment, user: usr)
        create(:comment, user: usr)
        create(:comment, user: usr)
      end
    end
  end
end
