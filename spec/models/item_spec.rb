require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:created_at) }
    it { should validate_presence_of(:updated_at) }
  end

  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  it 'best_sales_day' do

      merchant_1 = Merchant.create!(name: 'Lord Eldens', created_at: Time.now, updated_at: Time.now)
      customer_1 = create(:customer)
      item_9 = create(:item, name: 'Elden Ring', unit_price: 999, merchant_id: merchant_1.id)
      item_7 = create(:item, name: 'Demons Souls', unit_price: 888, merchant_id: merchant_1.id)
      item_11 = create(:item, name: 'Dark Souls 3', unit_price: 777, merchant_id: merchant_1.id)
      item_12 = create(:item, name: 'Doom', unit_price: 666, merchant_id: merchant_1.id)
      item_3 = create(:item, name: 'Bloodborne', unit_price: 555, merchant_id: merchant_1.id)
      item_1 = create(:item, name: 'Metal Gear', unit_price: 444, merchant_id: merchant_1.id)
      invoice_9 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2013-03-25 09:54:09 UTC".to_datetime, updated_at: Time.now)
      invoice_7 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2012-03-25 09:54:09 UTC".to_datetime, updated_at: Time.now)
      invoice_11 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2011-03-25 09:54:09 UTC".to_datetime, updated_at: Time.now)
      invoice_12 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2010-03-25 09:54:09 UTC".to_datetime, updated_at: Time.now)
      invoice_3 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2009-03-25 09:54:09 UTC".to_datetime, updated_at: Time.now)
      invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2, created_at: "2008-03-25 09:54:09 UTC".to_datetime, updated_at: Time.now)
      transaction_9 = Transaction.create!(credit_card_number: '103294023', credit_card_expiration_date: "342", result: 0,created_at: "2013-03-25 09:54:09 UTC", updated_at: Time.now, invoice_id: invoice_9.id)
      transaction_7 = Transaction.create!(credit_card_number: '103294023', credit_card_expiration_date: "342", result: 0,created_at: "2012-03-25 09:54:09 UTC", updated_at: Time.now, invoice_id: invoice_7.id)
      transaction_11 = Transaction.create!(credit_card_number: '103294023', credit_card_expiration_date: "342", result: 0,created_at: "2011-03-25 09:54:09 UTC", updated_at: Time.now, invoice_id: invoice_11.id)
      transaction_12 = Transaction.create!(credit_card_number: '103294023', credit_card_expiration_date: "342", result: 0,created_at: "2010-03-25 09:54:09 UTC", updated_at: Time.now, invoice_id: invoice_12.id)
      transaction_3 = Transaction.create!(credit_card_number: '103294023', credit_card_expiration_date: "342", result: 0,created_at: "2009-03-25 09:54:09 UTC", updated_at: Time.now, invoice_id: invoice_3.id)
      transaction_1 = Transaction.create!(credit_card_number: '103294023', credit_card_expiration_date: "342", result: 0,created_at: "2008-03-25 09:54:09 UTC", updated_at: Time.now, invoice_id: invoice_1.id)
      invoice_item_9 = create(:invoice_item, item_id: item_9.id, invoice_id: invoice_9.id, status: 2, quantity: 1, unit_price: 999)
      invoice_item_7 = create(:invoice_item, item_id: item_7.id, invoice_id: invoice_7.id, status: 2, quantity: 1, unit_price: 888)
      invoice_item_11 = create(:invoice_item, item_id: item_11.id, invoice_id: invoice_11.id, status: 2, quantity: 1, unit_price: 777)
      invoice_item_12 = create(:invoice_item, item_id: item_12.id, invoice_id: invoice_12.id, status: 2, quantity: 1, unit_price: 666)
      invoice_item_3 = create(:invoice_item, item_id: item_3.id, invoice_id: invoice_3.id, status: 2, quantity: 1, unit_price: 555)
      invoice_item_1 = create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id, status: 2, quantity: 1, unit_price: 444)



      expect(item_9.best_sales_day.created_at).to eq("2013-03-25 09:54:09 UTC".to_datetime)
      expect(item_7.best_sales_day.created_at).to eq("2012-03-25 09:54:09 UTC".to_datetime)
      expect(item_11.best_sales_day.created_at).to eq("2011-03-25 09:54:09 UTC".to_datetime)
      expect(item_12.best_sales_day.created_at).to eq("2010-03-25 09:54:09 UTC".to_datetime)
      expect(item_3.best_sales_day.created_at).to eq("2009-03-25 09:54:09 UTC".to_datetime)
      expect(item_1.best_sales_day.created_at).to eq("2008-03-25 09:54:09 UTC".to_datetime)
  end
end
