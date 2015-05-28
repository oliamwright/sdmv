class VenuesController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create
    Venue.create permit_param

    update_venue_person

    respond_to do |format|
      @venues = Venue.by_val
      @person_values = PersonValue.includes(:venue_person_values).all
      format.js { render action: "show"}
    end
  end

  def update
    venue = Venue.find(params["id"])
    venue.update_attributes permit_param

    update_venue_person

    respond_to do |format|  
      @venues = Venue.by_val
      @person_values = PersonValue.includes(:venue_person_values).all
      format.js { render action: "show"}
    end
  end

  def destroy
    Venue.destroy(params["id"])

    update_venue_person

    respond_to do |format|
      @venues = Venue.by_val
      @person_values = PersonValue.includes(:venue_person_values).all
      format.js { render action: "show"}
    end
  end

  private

  def permit_param
    params.require(:venue).permit :address, :x, :y, :category, :open_times_from, :open_times_to,
                                  :attendee_count, :contact, :booked
  end
 
end