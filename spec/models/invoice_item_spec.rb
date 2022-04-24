require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:created_at) }
    it { should validate_presence_of(:updated_at) }
  end

  describe 'relationships' do
    it { should belong_to(:item) }
    it { should belong_to(:invoice) }
  end

  describe 'instance methods' do

    it 'returns an invoice_items unit_price to dollars / formatted' do
      merch1 = FactoryBot.create(:merchant)
      cust1 = FactoryBot.create(:customer)
      item1 = Item.create!(name: 'Eldens Ring', description: 'its a ring', unit_price: 75107, merchant_id: merch1.id, created_at: Time.now, updated_at: Time.now)

      invoice1 = FactoryBot.create(:invoice, customer_id: cust1.id)
      invoice_item_1 = FactoryBot.create(:invoice_item, unit_price: item1.unit_price, item_id: item1.id, invoice_id: invoice1.id)
      expect(invoice_item_1.price_to_dollars).to eq(751.07)

    end

  it "#has_discount?" do
    merch1 = Merchant.create!(name: "Carl's Castles", created_at: Time.now, updated_at: Time.now)

    cust1 = Customer.create!(first_name: "Carl", last_name: "the Cat", created_at: Time.now, updated_at: Time.now)
    item1 = Item.create!(name: "Big Castle", description: "Our biggest castle", unit_price: 100, merchant_id: merch1.id, created_at: Time.now, updated_at: Time.now)
    item2 = Item.create!(name: "Medium Castle", description: "Our most medium castle", unit_price: 50, merchant_id: merch1.id, created_at: Time.now, updated_at: Time.now)
    item3 = Item.create!(name: "Small Castle", description: "Our smallest castle", unit_price: 25, merchant_id: merch1.id, created_at: Time.now, updated_at: Time.now)

    invoice1 = Invoice.create!(customer_id: cust1.id, created_at: Time.now, updated_at: Time.now)
    invoice_item_1 = InvoiceItem.create!(item_id: item1.id, unit_price: item1.unit_price, quantity: 3, invoice_id: invoice1.id, created_at: Time.now, updated_at: Time.now)
    invoice_item_2 = InvoiceItem.create!(item_id: item2.id, unit_price: item2.unit_price, quantity: 2, invoice_id: invoice1.id, created_at: Time.now, updated_at: Time.now)

    discount_1 = merch1.discounts.create!(percent: 10, threshold: 3)
  
    expect(invoice_item_1.has_discount?).to be true
    expect(invoice_item_2.has_discount?).to be false
  end

  it "#discount" do
    merch1 = Merchant.create!(name: "Carl's Castles", created_at: Time.now, updated_at: Time.now)

    cust1 = Customer.create!(first_name: "Carl", last_name: "the Cat", created_at: Time.now, updated_at: Time.now)
    item1 = Item.create!(name: "Big Castle", description: "Our biggest castle", unit_price: 100, merchant_id: merch1.id, created_at: Time.now, updated_at: Time.now)
    item2 = Item.create!(name: "Medium Castle", description: "Our most medium castle", unit_price: 50, merchant_id: merch1.id, created_at: Time.now, updated_at: Time.now)
    item3 = Item.create!(name: "Small Castle", description: "Our smallest castle", unit_price: 25, merchant_id: merch1.id, created_at: Time.now, updated_at: Time.now)

    invoice1 = Invoice.create!(customer_id: cust1.id, created_at: Time.now, updated_at: Time.now)
    invoice_item_1 = InvoiceItem.create!(item_id: item1.id, unit_price: item1.unit_price, quantity: 3, invoice_id: invoice1.id, created_at: Time.now, updated_at: Time.now)
    invoice_item_2 = InvoiceItem.create!(item_id: item2.id, unit_price: item2.unit_price, quantity: 2, invoice_id: invoice1.id, created_at: Time.now, updated_at: Time.now)

    discount_1 = merch1.discounts.create!(percent: 10, threshold: 3)
  
    expect(invoice_item_1.discount).to eq(discount_1)
  end

  end
end
