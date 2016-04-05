class AddClosedToReport < ActiveRecord::Migration
  def change
    add_column :reports, :closed, :boolean, default: false
  end
end
