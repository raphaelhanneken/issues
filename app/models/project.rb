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

class Project < ActiveRecord::Base
  has_many :reports, dependent: :destroy

  validates :name, presence: true,
                   length: { maximum: 80 }
end
