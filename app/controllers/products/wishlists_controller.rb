class Products::WishlistsController < ApplicationController
  before_action :set_product
  before_action :set_wishlist

  def create
    @wishlist.wishlist_products.create(product: @product)
    redirect_to @wishlist, notice: "#{@product.name} added to wishlist #{@wishlist.name}."
  end

  private
    def set_product
      @product = Product.find(params[:product_id])
    end

    def set_wishlist
      if params[:wishlist_id].present?
        @wishlist = Current.user.wishlists.find(params[:wishlist_id])
      else
        @wishlist = Current.user.wishlists.create(name: "My Wishslist")
      end
    end
end
