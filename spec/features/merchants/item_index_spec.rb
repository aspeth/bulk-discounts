require 'rails_helper'


RSpec.describe 'Merchant Item Index Page' do

  before do

    @merch1 = Merchant.create!(name: 'Jeffs Gold Blooms', created_at: Time.now, updated_at: Time.now)
    @item1 = @merch1.items.create!(name: "Golden Rose", description: "24k gold rose", unit_price: 100, created_at: Time.now, updated_at: Time.now, status: 1)
    @item2 = @merch1.items.create!(name: 'Dark Sole Shoes', description: "Dress shoes", unit_price: 200, created_at: Time.now, updated_at: Time.now)
    visit "/merchants/#{@merch1.id}/items"
  end

  describe 'As a Merchant' do

    it 'items index page shows my items' do
      expect(page).to have_content("Golden Rose")
      expect(page).to have_content('Dark Sole Shoes')
    end

    it 'every item name is a link to its show page' do
      click_link(@item1.name)
      expect(current_path).to eq("/merchants/#{@merch1.id}/items/#{@item1.id}")

    end

    it 'has a button to enable or disable each item' do
      merch1 = Merchant.create!(name: 'Jeffs Gold Blooms', created_at: Time.now, updated_at: Time.now)
      item1 = merch1.items.create!(name: "Golden Rose", description: "24k gold rose", unit_price: 100, created_at: Time.now, updated_at: Time.now, status: 1)
      item2 = merch1.items.create!(name: 'Dark Sole Shoes', description: "Dress shoes", unit_price: 200, created_at: Time.now, updated_at: Time.now)
      visit "/merchants/#{merch1.id}/items"

      within "#disabled-items" do
        expect(page).to_not have_content("Golden Rose")
        expect(page).to have_content("Dark Sole Shoes")
        click_button "Enable"
      end

      within "#disabled-items" do
        expect(page).to_not have_content("Golden Rose")
        expect(page).to_not have_content("Dark Sole Shoes")
      end

      within "#enabled-items" do
        expect(page).to have_content("Golden Rose")
        expect(page).to have_content("Dark Sole Shoes")
      end
    end
  end

  it 'I see two sections, one for enabled items and one for disabled items and each item is listed in the appropriate section' do
    merch1 = Merchant.create!(name: 'Jeffs Gold Blooms', created_at: Time.now, updated_at: Time.now)
    item1 = merch1.items.create!(name: "Golden Rose", description: "24k gold rose", unit_price: 100, created_at: Time.now, updated_at: Time.now, status: 1)
    item2 = merch1.items.create!(name: 'Dark Sole Shoes', description: "Dress shoes", unit_price: 200, created_at: Time.now, updated_at: Time.now)
    item3 = merch1.items.create!(name: "Emerald covered dinosaur egg", description: "The most ballinest chocolate egg you have ever seen", unit_price: 100000, created_at: Time.now, updated_at: Time.now, status: 1)
    item4 = merch1.items.create!(name: "Diamond dusted dodo egg", description: "Why let extinction stop you from enjoying this fine addition to any Kentucky Derby party spread", unit_price: 150699, created_at: Time.now, updated_at: Time.now)
    item5 = merch1.items.create!(name: "Faberge noodle ash tray", description: "You have never seen such a beautiful ash tray or your money back", unit_price: 50000, created_at: Time.now, updated_at: Time.now, status: 1)
    visit merchant_items_path(merch1)

    within "#enabled-items" do
      expect(page).to have_content("Golden Rose")
      expect(page).to have_content("Emerald covered dinosaur egg")
      expect(page).to have_content("Faberge noodle ash tray")
    end

    within "#disabled-items" do
      expect(page).to have_content("Dark Sole Shoes")
      expect(page).to have_content("Diamond dusted dodo egg")

    end
  end

  it 'shows 5 most popular items as links to their show pages with total revenue listed next to each item' do
    merchant_1 = Merchant.create!(name: 'Lord Eldens', created_at: Time.now, updated_at: Time.now)
    customer_1 = create(:customer)
    item_9 = create(:item, name: 'Elden Ring', unit_price: 999, merchant_id: merchant_1.id)
    item_7 = create(:item, name: 'Demons Souls', unit_price: 888, merchant_id: merchant_1.id)
    item_11 = create(:item, name: 'Dark Souls 3', unit_price: 777, merchant_id: merchant_1.id)
    item_12 = create(:item, name: 'Doom', unit_price: 666, merchant_id: merchant_1.id)
    item_3 = create(:item, name: 'Bloodborne', unit_price: 555, merchant_id: merchant_1.id)
    item_1 = create(:item, name: 'Metal Gear', unit_price: 444, merchant_id: merchant_1.id)
    invoice_9 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: Time.now, updated_at: Time.now)
    invoice_7 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: Time.now, updated_at: Time.now)
    invoice_11 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: Time.now, updated_at: Time.now)
    invoice_12 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: Time.now, updated_at: Time.now)
    invoice_3 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: Time.now, updated_at: Time.now)
    invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: Time.now, updated_at: Time.now)
    transaction_9 = FactoryBot.create(:transaction, 6, invoice_id: invoice_9.id, result: 0)
    transaction_7 = FactoryBot.create(:transaction, 6, invoice_id: invoice_7.id, result: 0)
    transaction_11 = FactoryBot.create(:transaction, 6, invoice_id: invoice_11.id, result: 0)
    transaction_12 = FactoryBot.create(:transaction, 6, invoice_id: invoice_12.id, result: 0)
    transaction_3 = FactoryBot.create(:transaction, 6, invoice_id: invoice_3.id, result: 0)
    transaction_1 = FactoryBot.create(:transaction, 6, invoice_id: invoice_1.id, result: 0)
    invoice_item_9 = create(:invoice_item, item_id: item_9.id, invoice_id: invoice_9.id, status: 2, quantity: 1, unit_price: 99)
    invoice_item_7 = create(:invoice_item, item_id: item_7.id, invoice_id: invoice_7.id, status: 2, quantity: 1, unit_price: 88)
    invoice_item_11 = create(:invoice_item, item_id: item_11.id, invoice_id: invoice_11.id, status: 2, quantity: 1, unit_price: 77)
    invoice_item_12 = create(:invoice_item, item_id: item_12.id, invoice_id: invoice_12.id, status: 2, quantity: 1, unit_price: 66)
    invoice_item_3 = create(:invoice_item, item_id: item_3.id, invoice_id: invoice_3.id, status: 2, quantity: 1, unit_price: 55)
    invoice_item_1 = create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id, status: 2, quantity: 1, unit_price: 44)
    visit merchant_items_path(merchant_1)

    within "#top-five-items" do
      expect(page).to have_content("Item: #{item_9.name} - Total Sales: 99")
      expect(page).to have_content("Item: #{item_7.name} - Total Sales: 88")
      expect(page).to have_content("Item: #{item_11.name} - Total Sales: 77")
      expect(page).to have_content("Item: #{item_12.name} - Total Sales: 66")
      expect(page).to have_content("Item: #{item_3.name} - Total Sales: 55")
      expect(page).to_not have_content("Item: #{item_1.name} - Total Sales: 44")
      expect(item_9.name).to appear_before(item_7.name)
      expect(item_7.name).to appear_before(item_11.name)
      expect(item_11.name).to appear_before(item_12.name)
      expect(item_12.name).to appear_before(item_3.name)
      expect(page).to have_link(item_9.name)
      click_link(item_9.name)
      expect(current_path).to eq(merchant_item_path(merchant_1, item_9))
    end
  end
end
# As a merchant
# When I visit my items index page
# Next to each item name I see a button to disable or enable that item.
# When I click this button
# Then I am redirected back to the items index
# And I see that the items status has changed
