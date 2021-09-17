module CalculateDistance
  def self.call(starting_adress, destination_adress)
    starting_result = Geocoder.search(starting_adress)
    starting_coordinates = starting_result.first.coordinates
    
    end_result = Geocoder.search(destination_adress)
    end_coordinates = end_result.first.coordinates
    
    distance = Geocoder::Calculations.distance_between(starting_coordinates, end_coordinates)
  end
end