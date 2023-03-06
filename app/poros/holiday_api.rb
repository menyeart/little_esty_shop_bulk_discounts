require './app/services/holiday_api_service.rb'


class HolidayApi 
  attr_reader :holidays, :holidays_and_dates
         
  def initialize(holiday_page)
    @holidays_and_dates = []
    @holidays = holiday_page.each_with_index do |holiday, index| 
      @holidays_and_dates << "Holiday: #{holiday[:name]}, Date: #{holiday[:date]}" unless index > 2
    end
  end
end


