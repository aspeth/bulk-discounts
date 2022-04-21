class GitHubService

  def conn(url)
    Faraday.new(url)
  end

  def get_json(response)
    JSON.parse(response.body, symbolize_names: true)
  end

  def get_repo_data
    response = conn('https://api.github.com').get('/repos/alexGrandolph/little-esty-shop')
    JSON.parse(response.body, symbolize_names: true)
  end

  def get_pull_data
    response = conn('https://api.github.com').get('/repos/alexGrandolph/little-esty-shop/pulls')
    JSON.parse(response.body, symbolize_names: true)
  end

  def get_contributors
    response = conn('https://api.github.com').get('/repos/alexGrandolph/little-esty-shop/contributors')
    JSON.parse(response.body, symbolize_names: true)
  end
end
