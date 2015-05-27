class ApplicationController < ActionController::Base
  include ActionView::Helpers::NumberHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def update_venue_person
    venues = Venue.all
    person_values = PersonValue.all
    venues.each do |venue|
      VenuePersonValue.where("venue_id = ?", venue.id).delete_all
      sum_dist = 0
      sum_value = 0

      person_values.each do |pv|
        vpv = VenuePersonValue.new
        vpv.venue_id = venue.id
        vpv.person_value_id = pv.id
        vpv.dist = number_with_precision(
          calculate_distance(venue.x, venue.y, pv.x, pv.y), :precision => 1)
        vpv.value = number_with_precision(
          (vpv.dist == 0 ? 0 : pv.int_lvl.to_f * pv.influence / vpv.dist), :precision => 1)

        if vpv.save
          sum_dist += vpv.dist
          sum_value += vpv.value
        end
      end

      venue.update_attributes(:sum_dist => sum_dist, :sum_value => sum_value)
    end
  end

  def update_int_lvl
    person_values = PersonValue.all

    person_values.each do |pv|
      keyword = pv.keywords

      same_count = 0
      similarity_percent = 0
      unless SimilarityCalculator.social_keywords.nil?
        keyword.split(',').each(&:strip!).each do |key|
          if SimilarityCalculator.social_keywords.include? key
            same_count += 1
          end
        end

        similarity_percent = same_count.to_f / SimilarityCalculator.social_keywords.split(' ').count;
      end

      pv.update_attributes(:int_lvl => similarity_percent)
    end
  end

  private

  # Calculate the distance between two points by Haversine formula
  # @param: x1 - latitude of first point
  # @param: x2 - longitude of first point
  # @param: y1 - latitude of second point
  # @param: y2 - longitude of second point
  # @return:  distance in feet
  def calculate_distance(x1, y1, x2, y2)
    earth_r = 6378137 # Earth’s mean radius in meter

    dLat = to_rad(x2 - x1)
    dLong = to_rad(y2 - y1)

    a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(to_rad(x1)) * Math.cos(to_rad(x2)) *
      Math.sin(dLong / 2) * Math.sin(dLong / 2);
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    d = earth_r * c * 3.2808399
    
    return d    
  end

  def to_rad(degree)
    degree * Math::PI / 180;
  end

end
