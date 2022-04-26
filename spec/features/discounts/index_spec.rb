require 'rails_helper'

RSpec.describe 'Merchant Discount Index' do

  before do
  end
  
  it "has all my bulk discounts with their percentages and thresholds, and has links to discount show page", :vcr do
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
  
  it "has a link to a form to add a new discount", :vcr do
    merch1 = Merchant.create!(name: 'Jeffs Gold Blooms', created_at: Time.now, updated_at: Time.now)
    merch2 = Merchant.create!(name: 'Miyazakis Dark Souls', created_at: Time.now, updated_at: Time.now)
    discount_1 = Discount.create!(percent: 10, threshold: 20, merchant_id: merch1.id)
    discount_2 = Discount.create!(percent: 20, threshold: 30, merchant_id: merch1.id)
    discount_3 = Discount.create!(percent: 15, threshold: 25, merchant_id: merch2.id)
    
    visit "/merchants/#{merch1.id}/discounts"

    expect(page).to_not have_content("Percent: 15%")
    expect(page).to_not have_content("Threshold: 25")
    
    click_link 'New Discount'
    
    fill_in 'Percent', with: '15'
    fill_in 'Threshold', with: '25'
    click_button 'Submit'
    
    expect(current_path).to eq("/merchants/#{merch1.id}/discounts")
    expect(page).to have_content("Percent: 15%")
    expect(page).to have_content("Threshold: 25")
  end
  
  it "displays error if percent > 100", :vcr do
    merch1 = Merchant.create!(name: 'Jeffs Gold Blooms', created_at: Time.now, updated_at: Time.now)
    merch2 = Merchant.create!(name: 'Miyazakis Dark Souls', created_at: Time.now, updated_at: Time.now)
    discount_1 = Discount.create!(percent: 10, threshold: 20, merchant_id: merch1.id)
    discount_2 = Discount.create!(percent: 20, threshold: 30, merchant_id: merch1.id)
    discount_3 = Discount.create!(percent: 15, threshold: 25, merchant_id: merch2.id)
    
    visit "/merchants/#{merch1.id}/discounts"

    click_link 'New Discount'
    
    fill_in 'Percent', with: '101'
    click_button 'Submit'

    expect(page).to have_content("Error: Please enter a whole number between 1 and 100")
  end
  
  it "displays error if percent < 0", :vcr do
    merch1 = Merchant.create!(name: 'Jeffs Gold Blooms', created_at: Time.now, updated_at: Time.now)
    merch2 = Merchant.create!(name: 'Miyazakis Dark Souls', created_at: Time.now, updated_at: Time.now)
    discount_1 = Discount.create!(percent: 10, threshold: 20, merchant_id: merch1.id)
    discount_2 = Discount.create!(percent: 20, threshold: 30, merchant_id: merch1.id)
    discount_3 = Discount.create!(percent: 15, threshold: 25, merchant_id: merch2.id)
    
    visit "/merchants/#{merch1.id}/discounts"

    click_link 'New Discount'
    
    fill_in 'Percent', with: '-1'
    click_button 'Submit'

    expect(page).to have_content("Error: Please enter a whole number between 1 and 100")
  end
  
  it "displays error if percent is not an integer", :vcr do
    merch1 = Merchant.create!(name: 'Jeffs Gold Blooms', created_at: Time.now, updated_at: Time.now)
    merch2 = Merchant.create!(name: 'Miyazakis Dark Souls', created_at: Time.now, updated_at: Time.now)
    discount_1 = Discount.create!(percent: 10, threshold: 20, merchant_id: merch1.id)
    discount_2 = Discount.create!(percent: 20, threshold: 30, merchant_id: merch1.id)
    discount_3 = Discount.create!(percent: 15, threshold: 25, merchant_id: merch2.id)
    
    visit "/merchants/#{merch1.id}/discounts"

    click_link 'New Discount'
    
    fill_in 'Percent', with: 'Hello'
    fill_in 'Threshold', with: 'Hello'
    click_button 'Submit'

    expect(page).to have_content("Error: Please enter a whole number between 1 and 100")
  end

  it "has a link to delete each discount", :vcr do
    merch1 = Merchant.create!(name: 'Jeffs Gold Blooms', created_at: Time.now, updated_at: Time.now)
    merch2 = Merchant.create!(name: 'Miyazakis Dark Souls', created_at: Time.now, updated_at: Time.now)
    discount_1 = Discount.create!(percent: 10, threshold: 20, merchant_id: merch1.id)
    discount_2 = Discount.create!(percent: 20, threshold: 30, merchant_id: merch1.id)
    discount_3 = Discount.create!(percent: 15, threshold: 25, merchant_id: merch2.id)
    
    visit "/merchants/#{merch1.id}/discounts"

    expect(page).to have_content("Percent: 10%")
    expect(page).to have_content("Threshold: 20")
    
    within "#discounts-#{discount_1.id}" do
      click_link "Delete Discount"
    end
    
    expect(current_path).to eq("/merchants/#{merch1.id}/discounts")
    expect(page).to_not have_content("Percent: 10%")
    expect(page).to_not have_content("Threshold: 20")
  end
  
  it "has upcoming holidays", :vcr do
    merch1 = Merchant.create!(name: 'Jeffs Gold Blooms', created_at: Time.now, updated_at: Time.now)
    merch2 = Merchant.create!(name: 'Miyazakis Dark Souls', created_at: Time.now, updated_at: Time.now)
    discount_1 = Discount.create!(percent: 10, threshold: 20, merchant_id: merch1.id)
    discount_2 = Discount.create!(percent: 20, threshold: 30, merchant_id: merch1.id)
    discount_3 = Discount.create!(percent: 15, threshold: 25, merchant_id: merch2.id)
    
    visit "/merchants/#{merch1.id}/discounts"
  
    expect(page).to have_content("Upcoming Holidays")
    expect(page).to have_content("Memorial Day")
    expect(page).to have_content("Juneteenth")
    expect(page).to have_content("Independence Day")
  end
end
# As a merchant
# When I visit the discounts index page
# I see a section with a header of "Upcoming Holidays"
# In this section the name and date of the next 3 upcoming US holidays are listed.

# Use the Next Public Holidays Endpoint in the [Nager.Date API](https://date.nager.at/swagger/index.html)