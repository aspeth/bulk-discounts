class Contributor
  attr_reader :login

  def initialize(data)
    require 'pry'; binding.pry
    @login = data[0][:login]
    #@login = {}
    # data.map do |contributor|
    #   if !@login.key?(contributor)
    #     @login[contributor[login]] = contributor[:contributions]
    #   end
    # end
  end
end
