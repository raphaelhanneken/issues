class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :title
      t.string :color

      t.timestamps null: false
    end
  end
end
