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

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :comments, dependent: :nullify
  has_many :reported, class_name: 'Report', foreign_key: 'reporter_id', dependent: :nullify
  has_many :assigned, class_name: 'Report', foreign_key: 'assignee_id', dependent: :nullify

  validates :firstname, presence: true,
                        length:   { within: 2..25 }

  validates :lastname, presence: true,
                       length:   { within: 2..25 }


  def name
    "#{firstname} #{lastname}"
  end

  def abbr
    "#{firstname[0]}#{lastname[0]}"
  end
end
