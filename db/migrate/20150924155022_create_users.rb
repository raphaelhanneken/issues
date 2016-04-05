class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :firstname, null: false
      t.string  :lastname,  null: false
      t.boolean :admin,     default: false

      t.timestamps null: false
    end
  end
end
