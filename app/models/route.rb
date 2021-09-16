class Route < ApplicationRecord
  validates :starting_adress, presence: true
  validates :destination_adress, presence: true
end