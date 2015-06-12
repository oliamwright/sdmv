class PersonValuesController < ApplicationController
  include ActionView::Helpers::NumberHelper

  skip_before_action :verify_authenticity_token

  def create
    original_params = permit_params
    original_params["x"] = get_latlong(request.remote_ip)[1]
    original_params["y"] = get_latlong(request.remote_ip)[0]
    PersonValue.create original_params

    update_int_lvl
    update_venue_person

    respond_to do |format|
      @person_values = PersonValue.all
      @venues = Venue.by_val
      format.js { render action: "show"}
    end
  end

  def update
    original_params = permit_params

    person_value = PersonValue.find(params["id"])
    person_value.update_attributes original_params

    update_int_lvl
    update_venue_person

    respond_to do |format|  
      @person_values = PersonValue.all
      @venues = Venue.by_val
      format.js { render action: "show"}
    end
  end

  def destroy
    PersonValue.destroy(params["id"])

    update_venue_person

    respond_to do |format|
      @person_values = PersonValue.all
      @venues = Venue.by_val
      format.js { render action: "show"}
    end
  end

  private

  def permit_params
    params.require(:person_value).permit :x, :y, :influence, :availability_from, :availability_to, :keywords
  end

  def get_latlong(ip_address)
    api_response = PersonLatLong.get_address_info ip_address
    [api_response["lat"], api_response["lon"]]    
  end
end