class Product < ApplicationRecord
  include Notifications

  has_rich_text :description
  has_one_attached :featured_image

  has_many :subscribers, dependent: :destroy
  has_many :wishlist_products, dependent: :destroy
  has_many :wishlists, through: :wishlist_products

  validates :name, presence: true
  validates :inventory_count, numericality: { integer_only: true, greater_than_or_equal_to: 0 }
end
