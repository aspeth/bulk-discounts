require 'rails_helper'

RSpec.describe 'the admin invoice show page' do
  it 'shows the invoice information including invoice id, status, created_at in readable format and customer first and last name' do
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
end
