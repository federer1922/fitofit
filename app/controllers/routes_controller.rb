class RoutesController < ApplicationController
  def create
    route = Route.new
    route.starting_adress = params["starting_adress"]
    route.destination_adress = params["destination_adress"]  
    if route.valid?
      route.distance = CalculateDistance.call(route.starting_adress, route.destination_adress)
      route.save!  
   
      redirect_to action: "index"
    else
      flash[:alert] = route.errors.full_messages.first

      redirect_to action: "index"
    end
  end

  def index
    @date_for_present_month = Date.today
    first_date_for_month = @date_for_present_month.beginning_of_month
    last_date_for_month = @date_for_present_month.end_of_month

    routes = Route.where(created_at: first_date_for_month..last_date_for_month)
    @routes = DayDistances.call(routes)
    if @routes.count == 0
      flash.now[:alert] = "No routes for this month" 
    end
  end
end