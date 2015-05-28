class HomeController < ApplicationController

  def index
    @venue = Venue.new
    @venues = Venue.by_val

    @person_value = PersonValue.new
    @person_values = PersonValue.all

    @item = Item.new
    @items = Item.all
  end
end