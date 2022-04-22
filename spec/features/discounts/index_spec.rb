require 'rails_helper'

RSpec.describe 'Merchant Discount Index' do

  before do
  end
  
  it "has all my bulk discounts with their percentages and thresholds, and has links to discount show page" do
    merch1 = Merchant.create!(name: 'Jeffs Gold Blooms', created_at: Time.now, updated_at: Time.now)
    merch2 = Merchant.create!(name: 'Miyazakis Dark Souls', created_at: Time.now, updated_at: Time.now)
    discount_1 = Discount.create!(percent: 10, threshold: 20, merchant_id: merch1.id)
    discount_2 = Discount.create!(percent: 20, threshold: 30, merchant_id: merch1.id)
    discount_3 = Discount.create!(percent: 15, threshold: 25, merchant_id: merch2.id)
    
    visit "/merchants/#{merch1.id}/discounts"

    expect(page).to_not have_content("Percent: 15%")
    expect(page).to_not have_content("Threshold: 25")

    within "#discounts-#{discount_1.id}" do
      expect(page).to have_content("Percent: 10%")
      expect(page).to have_content("Threshold: 20")
      click_link "Discount #{discount_1.id}"
    end

    expect(current_path).to eq("/merchants/#{merch1.id}/discounts/#{discount_1.id}")
  end
end

#    As a merchant
# When I visit my merchant dashboard
# Then I see a link to view all my discounts
# When I click this link
# Then I am taken to my bulk discounts index page
# Where I see all of my bulk discounts including their
# percentage discount and quantity thresholds
# And each bulk discount listed includes a link to its show page