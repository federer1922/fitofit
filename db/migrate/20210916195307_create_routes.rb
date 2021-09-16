class CreateRoutes < ActiveRecord::Migration[6.1]
  def change
    create_table :routes do |t|
      t.string :starting_adress
      t.string :destination_adress
      t.integer :distance
      t.timestamps
    end
  end
end
