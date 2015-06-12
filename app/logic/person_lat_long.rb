require 'httparty'

class PersonLatLong
  include HTTParty

  def self.get_address_info(ip_address)
    if ip_address == "127.0.0.1"
      response = HTTParty.get "http://ip-api.com/json"
    else
      response = HTTParty.get "http://ip-api.com/json/" + ip_address
    end
  end
end