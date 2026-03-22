class Store::WishlistsController < Store::BaseController
  def index
    @wishlists = Wishlist.filter_by(params)
  end

  def show
    @wishlist = Wishlist.find(params[:id])
  end
end
