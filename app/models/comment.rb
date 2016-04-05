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

class Comment < ActiveRecord::Base
  include PublicActivity::Model
  # TODO: Public Activity tracking
  # tracked

  belongs_to :user
  belongs_to :report

  validates :content, presence: true,
                      length: { maximum: 255 }

  validates :report, presence: true

  validates :user, presence: true
end
