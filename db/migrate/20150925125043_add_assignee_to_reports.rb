class AddAssigneeToReports < ActiveRecord::Migration
  def change
    add_reference :reports, :assignee, index: true, foreign_key: true
  end
end
