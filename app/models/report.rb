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

class Report < ActiveRecord::Base
  include PublicActivity::Model
  # TODO: Public Activity tracking
  # tracked

  belongs_to :project
  belongs_to :reporter, class_name: 'User', foreign_key: 'reporter_id'
  belongs_to :assignee, class_name: 'User', foreign_key: 'assignee_id'

  has_and_belongs_to_many :labels

  has_many :comments, dependent: :destroy

  scope :inbox,       -> (user) { where("closed = ? AND (assignee_id = ? OR reporter_id = ?)", false, user, user) }
  scope :assigned_to, -> (user) { where(closed: false, assignee: user) }
  scope :reported_by, -> (user) { where(closed: false, reporter: user) }
  scope :open,        -> { where(closed: false) }
  scope :closed,      -> { where(closed: true) }
  scope :unassigned,  -> { where(assignee: nil) }


  validates :title, presence: true,
                    length: { maximum: 80 }

  validates :description, presence: true,
                          length: { maximum: 1000 }

  validates :project, presence: true

  validates :reporter, presence: true


  def assignee?(user)
    user == assignee
  end

  def reporter?(user)
    user == reporter
  end
end
