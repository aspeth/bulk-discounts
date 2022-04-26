class Holiday
  attr_reader :holidays

  def initialize(data)
    @holidays = data[0..2].map do |holiday|
                  holiday[:name]
                end
  end
end