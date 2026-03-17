class ProductsController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]

  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products
  def index
    @products = Product.all
  end

  # GET /products/:id
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # POST /products
  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product, notice: "Product was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /products/:id/edit
  def edit
  end

  # PATCH/PUT /products/:id
  def update
    if @product.update(product_params)
      redirect_to @product, notce: "Product was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /products/:id
  def destroy
    @product.destroy
    redirect_to products_path, notice: "Product was successfully destroyed."
  end

  private
    def product_params
      params.expect(product: [ :name, :description, :featured_image ])
    end

    def set_product
      @product = Product.find(params[:id])
    end
end
