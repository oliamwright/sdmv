class VenuesController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create
    @venue = Venue.new
    @venue.x = params["venue"]["x"]
    @venue.y = params["venue"]["y"]
    @venue.save

    respond_to do |format|
      @venues = Venue.all
      format.js { render action: "show"}
    end
  end

  def update
    venue = Venue.find(params["id"])
    venue.update_attributes(:x => params["venue"]["x"], :y => params["venue"]["y"])

    respond_to do |format|  
      @venues = Venue.all
      format.js { render action: "show"}
    end
  end

  def destroy
    Venue.destroy(params["id"])

    respond_to do |format|
      @venues = Venue.all
      format.js { render action: "show"}
    end
  end

end