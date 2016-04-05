class AddReporterToReports < ActiveRecord::Migration
  def change
    add_reference :reports, :reporter, index: true, foreign_key: true
  end
end
