class VenuePersonValue < ActiveRecord::Base
  belongs_to :venue
  belongs_to :person_value
end