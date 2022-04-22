class DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end
  
  def show
    @discount = Discount.find(params[:id])
  end
  
  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merch_id = params[:id].to_i
    @merchant = Merchant.find(params[:merchant_id])
    
    if params[:percent].to_i > 100 || params[:percent].to_i < 0
      flash[:notice] = "Error: Please enter a whole number between 1 and 100"
      render :new
    else
      discount = @merchant.discounts.create!(discount_params)
      if discount.save
        redirect_to "/merchants/#{@merchant.id}/discounts"
      end
    end
  end
  
  def destroy
    merchant = Merchant.find(params[:merchant_id])
    discount = Discount.find(params[:id])
    discount.destroy
    redirect_to "/merchants/#{merchant.id}/discounts"
  end

    private

      def discount_params
        params.permit(:percent, :threshold, :merchant_id)
      end
end