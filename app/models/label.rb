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

class Label < ActiveRecord::Base
  include PublicActivity::Model

  has_and_belongs_to_many :reports

  validates :title, presence: true,
                    length: { maximum: 50 }

  validates :color, presence: true,
                    length: { is: 7 },
                    format: { with: /\#[a-fA-F0-9]{6}/,
                              message: 'only allows hex color strings, e.g. #FFFFFF' }
end
