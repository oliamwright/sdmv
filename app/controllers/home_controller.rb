class HomeController < ApplicationController

  def index
    @venue = Venue.new
    @venues = Venue.all
  end
end