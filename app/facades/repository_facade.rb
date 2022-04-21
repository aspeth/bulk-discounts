# require './app/services/github_service.rb'

class RepositoryFacade

  def initialize
  end
  # def self.create_or_error_message
  #   json = GitHubService.get_repo_data
  #   json[:message].nil? ? create_repo : json
  # end
  #
  # def self.create_repo
  #   json = GitHubService.get_repo_data
  #   Repository.new(json)
  # end

  def repo
    data = service.get_repo_data
    # if data[:message].nil?
      Repository.new(data)
    # else
    #   Repository.new(name: :data[:message])
    # end
    # json = service.get_repo_data
    # if json[:message].nil?
    #   Repository.new(json)
    # else
    #   json
    # end
  end

  def service
    @_service ||= GitHubService.new
  end

  # def contributors
  #   service.get_contributors.each do |data|
  #     Contributor.new(data)
  #   end
  # end
end
