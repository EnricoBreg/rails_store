class SubscribersController < ApplicationController
  allow_unauthenticated_access
  before_action :set_product

  # POST /products/:id/subscribers
  def create
    if @product.subscribers.where(subscriber_params).first_or_create
      redirect_to product_path(@product), notice: "You are now subscribed to this product."
    else
      redirect_to product_path(@product), alert: "There was a problem subscribing to this product. Please try again."
    end
  end

  private
    def set_product
      @product = Product.find(params[:product_id])
    end

    def subscriber_params
      params.expect(subscriber: [ :email ])
    end
end
