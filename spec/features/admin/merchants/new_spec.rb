require 'rails_helper'


RSpec.describe "Admin Merchants New Page" do
  describe "As a visitor, I can create a new merchant" do

    it 'submitting returns to admin/merchant index, with new merchant under disabled section' do
      visit "/admin/merchants/new"

      fill_in "Name", with: "Chungus Inc."

      click_on "Submit"
      expect(current_path).to eq("/admin/merchants/new")
      within "#all_disabled_merchants" do
        expect(page).to have_content("Chungus Inc.")
      end

    end 



  end 
end 