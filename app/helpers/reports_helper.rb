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

module ReportsHelper
end
