class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string     :title,       null: false
      t.text       :description, null: false
      t.references :project,     null: false, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
