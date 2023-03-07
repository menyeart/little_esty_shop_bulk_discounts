require './app/services/holiday_api_service.rb'


class HolidayApi 
  attr_reader 
         
  def initialize(holiday_page)
    @page =  holiday_page
  end

  def holidays_and_dates
    holidays_and_dates = []
    @page.each_with_index do |holiday, index| 
      holidays_and_dates << "Holiday: #{holiday[:name]}, Date: #{holiday[:date]}" unless index > 2
    end
    holidays_and_dates
  end
end