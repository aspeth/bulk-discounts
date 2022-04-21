require './app/services/github_service.rb'

class ContributorFacade

  def self.create_or_error_message
    json = GitHubService.get_contributor_data
    # json[:message].nil? ? create_contributor : json
  end

  def self.create_contributor
    json = GitHubService.get_contributor_data
    Contributor.new(json)
  end
end
