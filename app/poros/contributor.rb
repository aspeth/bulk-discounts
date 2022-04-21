class Contributor
  attr_reader :names

  def initialize(data)
    @names = []
    # require 'pry'; binding.pry
    data.each do |guy|
      @names << guy[:login]
    end
    # require 'pry'; binding.pry
    # @login = data[0][:login]
    #@login = {}
    # data.map do |contributor|
    #   if !@login.key?(contributor)
    #     @login[contributor[login]] = contributor[:contributions]
    #   end
    # end
  end
end
