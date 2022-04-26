class HolidayService
  def get_holiday
    get_url("api/v2/NextPublicHolidays/US")
  end

  def get_url(url)
    response = HTTParty.get("https://date.nager.at/#{url}")
    JSON.parse(response.body, symbolize_names: true)
  end
end