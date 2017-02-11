class OrdersController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    @order = Order.find(params[:id])
    @order.user = current.user
    @order.total = current_cart.total_price

    if @order.save
      redirect_to oreder_path(@order)
    else
      render "carts.checkout"
    end

    private

    def order_params
      params.require(:order).permit(:billing_name, :billing_address, :shipping_name, :shipping_address)
    end



end
