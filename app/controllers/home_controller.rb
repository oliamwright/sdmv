class HomeController < ApplicationController

  def index
    @venue = Venue.new
    @venues = Venue.all

    @person_value = PersonValue.new
    @person_values = PersonValue.all

    @item = Item.new
    @items = Item.all
  end
end