class HolidayFacade
  def holidays
    service.get_holiday.first(3).map do |data|
      Holiday.new(data)
    end
  end

  # def holiday_data
  #   @_holiday_data ||= service.get_holiday
  # end

  def service
    @_service ||= HolidayService.new
  end
end