require 'rails_helper'


RSpec.describe 'Merchant Invoice Show Page' do

  describe 'As a visitor' do

    it 'I see the invoices id, status, formated created at date, customer first and last name' , :vcr do
      merch1 = FactoryBot.create(:merchant)
      cust1 = FactoryBot.create(:customer)
      item1 = FactoryBot.create(:item, merchant_id: merch1.id)
      item2 = FactoryBot.create(:item, merchant_id: merch1.id)
      item3 = FactoryBot.create(:item, merchant_id: merch1.id)
      invoice1 = FactoryBot.create(:invoice, created_at: Time.now, customer_id: cust1.id)
      invoice_item_1 = FactoryBot.create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id)

      visit "/merchants/#{merch1.id}/invoices/#{invoice1.id}"
      # save_and_open_page
      expect(page).to have_content("Invoice ID: #{invoice1.id}")
      expect(page).to have_content("Status: #{invoice1.status}")
      expect(page).to have_content("Created At: #{invoice1.formatted_created_at}")
      expect(page).to have_content("Customer Name: #{invoice1.customer_name}")
    end

    it 'I see ONLY items that are mine and those items attributes' , :vcr do
      merch1 = FactoryBot.create(:merchant)
      merch2 = FactoryBot.create(:merchant)
      cust1 = FactoryBot.create(:customer)
      item1 = FactoryBot.create(:item, merchant_id: merch1.id)
      item2 = FactoryBot.create(:item, merchant_id: merch1.id)
      item3 = FactoryBot.create(:item, merchant_id: merch1.id)
      item4 = FactoryBot.create(:item, merchant_id: merch2.id)

      invoice1 = FactoryBot.create(:invoice, customer_id: cust1.id)
      invoice_item_1 = FactoryBot.create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id)
      invoice_item_2 = FactoryBot.create(:invoice_item, item_id: item2.id, invoice_id: invoice1.id)
      invoice_item_3 = FactoryBot.create(:invoice_item, item_id: item3.id, invoice_id: invoice1.id)
      invoice_item_4 = FactoryBot.create(:invoice_item, item_id: item4.id, invoice_id: invoice1.id)

      visit "/merchants/#{merch1.id}/invoices/#{invoice1.id}"
      # require "pry"; binding.pry
      expect(page).to have_content("My Items on This Invoice:")
      # save_and_open_page
      within "#invoice_item-#{invoice_item_1.id}" do
        expect(page).to have_content("Item Name: #{item1.name}")
        expect(page).to have_content("Quantity Ordered: #{invoice_item_1.quantity}")
        expect(page).to have_content("Item Price: #{invoice_item_1.price_to_dollars}")
        expect(page).to have_content("Invoice Item Status: #{invoice_item_1.status}")
      end
      within "#invoice_item-#{invoice_item_2.id}" do
        expect(page).to have_content("Item Name: #{item2.name}")
        expect(page).to have_content("Quantity Ordered: #{invoice_item_2.quantity}")
        expect(page).to have_content("Item Price: #{invoice_item_2.price_to_dollars}")
        expect(page).to have_content("Invoice Item Status: #{invoice_item_2.status}")
      end
      within "#invoice_item-#{invoice_item_3.id}" do
        expect(page).to have_content("Item Name: #{item3.name}")
        expect(page).to have_content("Quantity Ordered: #{invoice_item_3.quantity}")
        expect(page).to have_content("Item Price: #{invoice_item_3.price_to_dollars}")
        expect(page).to have_content("Invoice Item Status: #{invoice_item_3.status}")
      end

      expect(page).to_not have_content("#{item4.name}")
      expect(page).to_not have_content("#{invoice_item_4.price_to_dollars}")

    end

    it 'I see the total revenue that will be generated from all my items on the invoice' , :vcr do
      merch1 = FactoryBot.create(:merchant)
      # merch2 = FactoryBot.create(:merchant)
      cust1 = FactoryBot.create(:customer)
      item1 = FactoryBot.create(:item, unit_price: 75107, merchant_id: merch1.id)
      item2 = FactoryBot.create(:item, unit_price: 59999, merchant_id: merch1.id)
      item3 = FactoryBot.create(:item, unit_price: 65734, merchant_id: merch1.id)
      # item4 = FactoryBot.create(:item, unit_price: 45345, merchant_id: merch2.id)

      invoice1 = FactoryBot.create(:invoice, customer_id: cust1.id)
      invoice_item_1 = FactoryBot.create(:invoice_item, item_id: item1.id, unit_price: item1.unit_price, quantity: 3, invoice_id: invoice1.id)
      invoice_item_2 = FactoryBot.create(:invoice_item, item_id: item2.id, unit_price: item2.unit_price, quantity: 1, invoice_id: invoice1.id)
      invoice_item_3 = FactoryBot.create(:invoice_item, item_id: item3.id, unit_price: item3.unit_price, quantity: 2, invoice_id: invoice1.id)
      # invoice_item_4 = FactoryBot.create(:invoice_item, item_id: item4.id, unit_price: item4.unit_price, quantity: 1, nvoice_id: invoice1.id)

      visit "/merchants/#{merch1.id}/invoices/#{invoice1.id}"
      expect(page).to have_content("Total Revenue From This Invoice:")
      within "#total_revenue" do
        expect(page).to have_content("$4167.88")
      end
    end

    it 'has a drop down menu for each invoice item status, to change said status', :vcr do
      merch1 = FactoryBot.create(:merchant)
      cust1 = FactoryBot.create(:customer)
      item1 = FactoryBot.create(:item, unit_price: 75107, merchant_id: merch1.id)
      item2 = FactoryBot.create(:item, unit_price: 59999, merchant_id: merch1.id)
      invoice1 = FactoryBot.create(:invoice, customer_id: cust1.id)
      invoice_item_1 = FactoryBot.create(:invoice_item, item_id: item1.id, unit_price: item1.unit_price, quantity: 3, status: 0, invoice_id: invoice1.id)
      invoice_item_2 = FactoryBot.create(:invoice_item, item_id: item2.id, unit_price: item2.unit_price, quantity: 1, status: 1, invoice_id: invoice1.id)

      visit "/merchants/#{merch1.id}/invoices/#{invoice1.id}"
      expect(page).to have_button("Update Item Status")

      within "#invoice_item-#{invoice_item_1.id}" do
        expect(find_field('status').value).to eq('packaged')
        select 'shipped'
        click_button 'Update Item Status'
      end
      expect(current_path).to eq("/merchants/#{merch1.id}/invoices/#{invoice1.id}")

      within "#invoice_item-#{invoice_item_1.id}" do
        expect(page).to have_content("shipped")
      end
    end

  end

  it "has a section for both total and discounted revenue" do
    merch1 = Merchant.create!(name: "Carl's Castles", created_at: Time.now, updated_at: Time.now)

    cust1 = Customer.create!(first_name: "Carl", last_name: "the Cat", created_at: Time.now, updated_at: Time.now)
    item1 = Item.create!(name: "Big Castle", description: "Our biggest castle", unit_price: 100, merchant_id: merch1.id, created_at: Time.now, updated_at: Time.now)
    item2 = Item.create!(name: "Medium Castle", description: "Our most medium castle", unit_price: 50, merchant_id: merch1.id, created_at: Time.now, updated_at: Time.now)
    item3 = Item.create!(name: "Small Castle", description: "Our smallest castle", unit_price: 25, merchant_id: merch1.id, created_at: Time.now, updated_at: Time.now)

    invoice1 = Invoice.create!(customer_id: cust1.id, created_at: Time.now, updated_at: Time.now)
    invoice_item_1 = InvoiceItem.create!(item_id: item1.id, unit_price: item1.unit_price, quantity: 3, invoice_id: invoice1.id, created_at: Time.now, updated_at: Time.now)
    invoice_item_2 = InvoiceItem.create!(item_id: item2.id, unit_price: item2.unit_price, quantity: 3, invoice_id: invoice1.id, created_at: Time.now, updated_at: Time.now)
    invoice_item_3 = InvoiceItem.create!(item_id: item3.id, unit_price: item3.unit_price, quantity: 3, invoice_id: invoice1.id, created_at: Time.now, updated_at: Time.now)

    discount_1 = merch1.discounts.create!(percent: 10, threshold: 3)
  
    visit "/merchants/#{merch1.id}/invoices/#{invoice1.id}"
    expect(page).to have_content("Total Revenue From This Invoice:")
    within "#total_revenue" do
      expect(page).to have_content("$5.25")
    end
    
    expect(page).to have_content("Discounted Revenue From This Invoice:")
    within "#discounted_revenue" do
      expect(page).to have_content("$0.53")
    end
  end

  it "has a section for revenue after discount" do
    merch1 = Merchant.create!(name: "Carl's Castles", created_at: Time.now, updated_at: Time.now)

    cust1 = Customer.create!(first_name: "Carl", last_name: "the Cat", created_at: Time.now, updated_at: Time.now)
    item1 = Item.create!(name: "Big Castle", description: "Our biggest castle", unit_price: 100, merchant_id: merch1.id, created_at: Time.now, updated_at: Time.now)
    item2 = Item.create!(name: "Medium Castle", description: "Our most medium castle", unit_price: 50, merchant_id: merch1.id, created_at: Time.now, updated_at: Time.now)
    item3 = Item.create!(name: "Small Castle", description: "Our smallest castle", unit_price: 25, merchant_id: merch1.id, created_at: Time.now, updated_at: Time.now)

    invoice1 = Invoice.create!(customer_id: cust1.id, created_at: Time.now, updated_at: Time.now)
    invoice_item_1 = InvoiceItem.create!(item_id: item1.id, unit_price: item1.unit_price, quantity: 3, invoice_id: invoice1.id, created_at: Time.now, updated_at: Time.now)
    invoice_item_2 = InvoiceItem.create!(item_id: item2.id, unit_price: item2.unit_price, quantity: 3, invoice_id: invoice1.id, created_at: Time.now, updated_at: Time.now)
    invoice_item_3 = InvoiceItem.create!(item_id: item3.id, unit_price: item3.unit_price, quantity: 3, invoice_id: invoice1.id, created_at: Time.now, updated_at: Time.now)

    discount_1 = merch1.discounts.create!(percent: 10, threshold: 3)
  
    visit "/merchants/#{merch1.id}/invoices/#{invoice1.id}"
    expect(page).to have_content("Revenue From This Invoice After Discount:")
    within "#revenue_after_discount" do
      expect(page).to have_content("$4.73")
    end
  end

  it "links to discount show page" do
    merch1 = Merchant.create!(name: "Carl's Castles", created_at: Time.now, updated_at: Time.now)

    cust1 = Customer.create!(first_name: "Carl", last_name: "the Cat", created_at: Time.now, updated_at: Time.now)
    item1 = Item.create!(name: "Big Castle", description: "Our biggest castle", unit_price: 100, merchant_id: merch1.id, created_at: Time.now, updated_at: Time.now)
    item2 = Item.create!(name: "Medium Castle", description: "Our most medium castle", unit_price: 50, merchant_id: merch1.id, created_at: Time.now, updated_at: Time.now)
    item3 = Item.create!(name: "Small Castle", description: "Our smallest castle", unit_price: 25, merchant_id: merch1.id, created_at: Time.now, updated_at: Time.now)

    invoice1 = Invoice.create!(customer_id: cust1.id, created_at: Time.now, updated_at: Time.now)
    invoice_item_1 = InvoiceItem.create!(item_id: item1.id, unit_price: item1.unit_price, quantity: 3, invoice_id: invoice1.id, created_at: Time.now, updated_at: Time.now)
    invoice_item_2 = InvoiceItem.create!(item_id: item2.id, unit_price: item2.unit_price, quantity: 2, invoice_id: invoice1.id, created_at: Time.now, updated_at: Time.now)

    discount_1 = merch1.discounts.create!(percent: 10, threshold: 3)
  
    visit "/merchants/#{merch1.id}/invoices/#{invoice1.id}"

    within "#invoice_item-#{invoice_item_2.id}" do
      expect(page).to_not have_link("Discount Applied")
    end

    within "#invoice_item-#{invoice_item_1.id}" do
      click_link "Discount Applied"
    end

    expect(current_path).to eq("/merchants/#{merch1.id}/discounts/#{discount_1.id}")
  end
end
# As a merchant
# When I visit my merchant invoice show page
# Next to each invoice item I see a link to the show page for the bulk discount that was applied (if any)