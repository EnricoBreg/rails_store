class Wishlist < ApplicationRecord
  belongs_to :user
  has_many :wishlist_products, dependent: :destroy
  has_many :products, through: :wishlist_products

=begin   def to_param
    # Squish rimuove spazi extra e parameterize rende la stringa URL-friendly
    "#{id}-#{name.squish.parameterize}"
  end
=end

  to_param :name
end
