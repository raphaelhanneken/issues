class CreateJoinTableLabelReport < ActiveRecord::Migration
  def change
    create_join_table :labels, :reports do |t|
      t.index [:label_id, :report_id], unique: true
      t.index [:report_id, :label_id], unique: true
    end
  end
end
