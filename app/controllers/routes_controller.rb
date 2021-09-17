class RoutesController < ApplicationController
  def create
    route = Route.new
    route.starting_adress = params["starting_adress"]
    route.destination_adress = params["destination_adress"]  
    if route.save
      starting_result = Geocoder.search(route.starting_adress)
      starting_coordinates = starting_result.first.coordinates
      
      end_result = Geocoder.search(route.destination_adress)
      end_coordinates = end_result.first.coordinates
       
      route.distance = Geocoder::Calculations.distance_between(starting_coordinates, end_coordinates)
      route.save!  
   
      redirect_to action: "index"
    else
      flash[:alert] = route.errors.full_messages.first

      redirect_to action: "index"
    end
  end

  def index
    @routes = Route.all.order(:created_at)
  end
end