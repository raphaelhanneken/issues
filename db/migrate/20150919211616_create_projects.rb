class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name,    null: false
      t.string :version, default: ''

      t.timestamps null: false
    end
  end
end
