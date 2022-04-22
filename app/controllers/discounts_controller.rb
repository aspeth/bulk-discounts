class DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end
  
  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:id])
  end
  
  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merch_id = params[:id].to_i
    merchant = Merchant.find(params[:merchant_id])
    discount = merchant.discounts.create!(discount_params)
    if discount.save
    redirect_to "/merchants/#{merchant.id}/discounts"
    end
  end

  private

    def discount_params
      params.permit(:percent, :threshold, :merchant_id)
    end
end