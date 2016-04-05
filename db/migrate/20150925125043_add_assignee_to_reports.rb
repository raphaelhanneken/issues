class AddAssigneeToReports < ActiveRecord::Migration
  def change
    add_reference :reports, :assignee, references: :users, index: true, foreign_key: true
  end
end
