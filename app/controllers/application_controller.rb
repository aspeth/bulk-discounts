class ApplicationController < ActionController::Base
  before_action :repo_info, only: [:index, :show, :edit, :new]
  before_action :contributor_info, only: [:index, :show, :edit, :new]

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end


  def repo_info
    facade = RepositoryFacade.new
    @repo = facade.repo
  end

  def contributor_info
    facade = ContributorFacade.new
    @contributor = facade.very_swag_my_guy
  end
end
