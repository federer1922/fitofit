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

  def show_month_details
    @date_for_month = Date.parse(params["day"])
    first_date_for_month = @date_for_month.beginning_of_month
    last_date_for_month = @date_for_month.end_of_month
    @routes = Route.where(created_at: first_date_for_month..last_date_for_month)
  end

  def show_day_details
    @date = Date.parse(params["day"])
    @routes = Route.where(created_at: @date.beginning_of_day..@date.end_of_day)
  end

  def destroy
    route = Route.find params["route_id"]
    route.destroy!

    if params["click_source"] == "show_month_details"
      if Route.where(created_at: route.created_at.beginning_of_month..route.created_at.end_of_month).count == 0 
        flash[:alert] = "No routes for this month, back to the main site"
        redirect_to action: "index" 
      else
        redirect_to action: "show_month_details", params: { day: params["day"] }
      end
    else
      if Route.where(created_at: route.created_at.beginning_of_day..route.created_at.end_of_day).count == 0
        flash[:alert] = "No routes for this day, back to the main site"
        redirect_to action: "index"
      else
        redirect_to action: "show_day_details", params: { day: params["day"] }
      end
    end
  end
end