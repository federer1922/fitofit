class ChangeDistanceToBeDecimalInRoute < ActiveRecord::Migration[6.1]
  def change
    change_column :routes, :distance, :decimal, precision: 7, scale: 2, default: 0
  end
end
