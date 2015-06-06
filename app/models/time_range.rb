##
# Polymorphic time range
#
class TimeRange < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
end
