require 'rails_helper'

RSpec.describe 'the admin invoice show page' do
  it 'shows the invoice information including invoice id, status, created_at in readable format and customer first and last name' , :vcr do
    merchant_1 = Merchant.create!(name: "Elron Hubbard", created_at: Time.now, updated_at: Time.now)
    customer_1 = Customer.create!(first_name: "Squeaky", last_name: "Clean", created_at: Time.now, updated_at: Time.now)
    item_1 = FactoryBot.create(:item, merchant_id: merchant_1.id)
    invoice_1 = FactoryBot.create(:invoice, created_at: Time.now, customer_id: customer_1.id)
    invoice_item_1 = FactoryBot.create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id)
    visit "/admin/invoices/#{invoice_1.id}"

    expect(page).to have_content("Invoice Id: #{invoice_1.id}")
    expect(page).to have_content("Status: #{invoice_1.status}")
    expect(page).to have_content("Created: #{invoice_1.formatted_created_at}")
    expect(page).to have_content("Customer First Name: #{customer_1.first_name}")
    expect(page).to have_content("Customer Last Name: #{customer_1.last_name}")
  end

  describe 'As an Admin' do
    before do
      @merchant_1 = create(:merchant)
      @customer_1 = create(:customer)
      @invoice_1 = create(:invoice, status: 1, customer_id: @customer_1.id, created_at: "2012-03-25 09:54:09 UTC")
      @item_1 = create(:item, merchant_id: @merchant_1.id)
      @item_11 = create(:item, merchant_id: @merchant_1.id)
      @item_111 = create(:item, merchant_id: @merchant_1.id)
      @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, status: 0, quantity: 1, unit_price: 101)
      @invoice_item_11 = create(:invoice_item, item_id: @item_11.id, invoice_id: @invoice_1.id, status: 1, quantity: 2, unit_price: 201)
      @invoice_item_111 = create(:invoice_item, item_id: @item_111.id, invoice_id: @invoice_1.id, status: 2, quantity: 3, unit_price: 300)

      visit "/admin/invoices/#{@invoice_1.id}"

    end

    it 'lists the item names on the invoice' , :vcr do
      expect(page).to have_content("#{@item_1.name}")
      expect(page).to have_content("#{@item_11.name}")
      expect(page).to have_content("#{@item_111.name}")
    end

    it 'shows the unit price and quantity sold for each item', :vcr do
      expect(page).to have_content("Price: $1.01")
      expect(page).to have_content("Price: $2.01")
      expect(page).to have_content("Price: $3.00")
      expect(page).to have_content("Quantity sold: 1")
      expect(page).to have_content("Quantity sold: 2")
      expect(page).to have_content("Quantity sold: 3")
      expect(page).to have_content("Status: packaged")
      expect(page).to have_content("Status: pending")
      expect(page).to have_content("Status: shipped")
    end

    it 'will return total revenue from this invoice', :vcr do
      expect(page).to have_content("Total Revenue: $14.03")
    end

    it 'shows invoice status in a select field, and I can select a new status', :vcr do
      expect(page).to have_content("Invoice Status: in progress")
        within("#invoice_status_update")do
          expect(find_field('invoice_status').value).to eq('in progress')
          select('completed')
          click_button('Submit')
        end
      expect(current_path).to eq("/admin/invoices/#{@invoice_1.id}")
        within("#invoice_status_update") do
          expect(page).to have_content("Invoice Status: completed")
        end
    end

    it "has a section for discounted revenue" do
      merch1 = Merchant.create!(name: "Carl's Castles", created_at: Time.now, updated_at: Time.now)
      merch2 = Merchant.create!(name: "Soren's Shoes", created_at: Time.now, updated_at: Time.now)

      cust1 = Customer.create!(first_name: "Carl", last_name: "the Cat", created_at: Time.now, updated_at: Time.now)
      item1 = merch1.items.create!(name: "Big Castle", description: "Our biggest castle", unit_price: 100, created_at: Time.now, updated_at: Time.now)
      item2 = merch1.items.create!(name: "Medium Castle", description: "Our most medium castle", unit_price: 50, created_at: Time.now, updated_at: Time.now)
      item3 = merch1.items.create!(name: "Small Castle", description: "Our smallest castle", unit_price: 25, created_at: Time.now, updated_at: Time.now)
      item4 = merch2.items.create!(name: "Big Castle", description: "Our biggest castle", unit_price: 100, created_at: Time.now, updated_at: Time.now)
      item5 = merch2.items.create!(name: "Medium Castle", description: "Our most medium castle", unit_price: 50, created_at: Time.now, updated_at: Time.now)
      item6 = merch2.items.create!(name: "Small Castle", description: "Our smallest castle", unit_price: 25, created_at: Time.now, updated_at: Time.now)

      invoice1 = Invoice.create!(customer_id: cust1.id, created_at: Time.now, updated_at: Time.now)
      invoice_item_1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, unit_price: item1.unit_price, quantity: 3, created_at: Time.now, updated_at: Time.now)
      invoice_item_1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item2.id, unit_price: item2.unit_price, quantity: 3, created_at: Time.now, updated_at: Time.now)
      invoice_item_2 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item3.id, unit_price: item3.unit_price, quantity: 2, created_at: Time.now, updated_at: Time.now)
      invoice_item_4 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item4.id, unit_price: item4.unit_price, quantity: 3, created_at: Time.now, updated_at: Time.now)
      invoice_item_5 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item5.id, unit_price: item5.unit_price, quantity: 2, created_at: Time.now, updated_at: Time.now)

      discount_1 = merch1.discounts.create!(percent: 30, threshold: 5)
      discount_2 = merch1.discounts.create!(percent: 10, threshold: 3)
      discount_3 = merch2.discounts.create!(percent: 20, threshold: 3)
    
      visit "/admin/invoices/#{invoice1.id}"

      expect(page).to have_content("Revenue From This Invoice After Discount:")

      within "#revenue_after_discount" do
        expect(page).to have_content("Revenue: $6.25")
      end
    end
  end
end
# As an admin
# When I visit an admin invoice show page
# Then I see the total revenue from this invoice (not including discounts)
# And I see the total discounted revenue from this invoice which includes bulk discounts in the calculation