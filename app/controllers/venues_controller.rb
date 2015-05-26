class VenuesController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create
    @venue = Venue.new
    @venue.x = params["venue"]["x"]
    @venue.y = params["venue"]["y"]
    @venue.save

    update_venue_person

    respond_to do |format|
      @venues = Venue.all
      @person_values = PersonValue.includes(:venue_person_values).all
      format.js { render action: "show"}
    end
  end

  def update
    venue = Venue.find(params["id"])
    venue.update_attributes(:x => params["venue"]["x"], :y => params["venue"]["y"])

    update_venue_person

    respond_to do |format|  
      @venues = Venue.all
      @person_values = PersonValue.includes(:venue_person_values).all
      format.js { render action: "show"}
    end
  end

  def destroy
    Venue.destroy(params["id"])

    update_venue_person

    respond_to do |format|
      @venues = Venue.all
      @person_values = PersonValue.includes(:venue_person_values).all
      format.js { render action: "show"}
    end
  end

  private
 

end