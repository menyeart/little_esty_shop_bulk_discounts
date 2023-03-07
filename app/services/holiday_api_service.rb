require 'json'
require 'httparty'

class HolidayApiService 
  def self.get_url(url) 
    response = HTTParty.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.holiday_page
    get_url("https://date.nager.at/api/v3/NextPublicHolidays/US")
  end
end