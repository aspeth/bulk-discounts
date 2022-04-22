require 'rails_helper'

RSpec.describe 'Merchant Discount Show' do

it "has the bulk discount's percentage and threshold" do
  merch1 = Merchant.create!(name: 'Jeffs Gold Blooms', created_at: Time.now, updated_at: Time.now)
  merch2 = Merchant.create!(name: 'Miyazakis Dark Souls', created_at: Time.now, updated_at: Time.now)
  discount_1 = Discount.create!(percent: 10, threshold: 20, merchant_id: merch1.id)
  discount_2 = Discount.create!(percent: 20, threshold: 30, merchant_id: merch1.id)
  discount_3 = Discount.create!(percent: 15, threshold: 25, merchant_id: merch2.id)
  
  visit "/merchants/#{merch1.id}/discounts/#{discount_1.id}"

  expect(page).to_not have_content("Percent: 20%")
  expect(page).to_not have_content("Threshold: 30")
  expect(page).to_not have_content("Percent: 15%")
  expect(page).to_not have_content("Threshold: 25")

  expect(page).to have_content("Percent: 10%")
  expect(page).to have_content("Threshold: 20")
  end
end
# As a merchant
# When I visit my bulk discount show page
# Then I see the bulk discount's quantity threshold and percentage discount