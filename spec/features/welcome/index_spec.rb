require 'rails_helper'

RSpec.describe 'welcome page', type: :feature do
  context 'as a visitor' do
    it 'shows the GitHub repo name' do
      visit "/"

      expect(page).to have_content("alexGrandolph/little-esty-shop")
    end
  end
end