# require './app/services/github_service.rb'

class ContributorFacade

def initialize

end

  def very_swag_my_guy
    data = service.get_contributors
    Contributor.new(data)
  end
  # def self.create_or_error_message
  #   json = GitHubService.get_contributor_data
  #   # json[:message].nil? ? create_contributor : json
  # end
  #
  # def self.create_contributor
  #   json = GitHubService.get_contributor_data
  #   Contributor.new(json)
  # end

  def service
    @_service ||= GitHubService.new
  end

  def contributors
    service.get_contributors.each do |data|
      Contributor.new(data)
    end
  end
end
