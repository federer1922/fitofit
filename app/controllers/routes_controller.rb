class RoutesController < ApplicationController
  def create
    route = Route.new
    route.starting_adress = params["starting_adress"]
    route.destination_adress = params["destination_adress"]
    if route.save
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