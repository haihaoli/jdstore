class Admin::ProductsController < AdminController
  before_action :find_product, only: [:edit, :update, :destroy]

  def new
    @product = Product.new
    @photos = @product.photos.build #for multi-pics
    @categories = Category.all.map { |c| [c.name, c.id] }
  end

  def create
    @product = Product.new(product_params)
    @product.category_id = params[:category_id]

    if @product.save
      if params[:photos] != nil
        params[:photos]['avatar'].each do |a|
          @photos = @product.photos.create(:avatar => a)
        end
      end
      redirect_to admin_products_path

    else
      render :new
    end
  end

  def index
    @products = Product.all.order("created_at DESC").paginate(:page => params[:page], :per_page => 4)
  end

  def edit
    @categories = Category.all.map { |c| [c.name, c.id] }
  end

  def update
    @product.category_id = params[:category_id]

    if params[:photos] != nil
        @product.photos.destroy_all #need to destroy old pics first
        params[:photos]['avatar'].each do |a|
          @picture = @product.photos.create(:avatar => a)
        end
        @product.update(product_params)
        redirect_to edit_admin_product_path
      elsif @product.update(product_params)
      redirect_to edit_admin_product_path
    else
      render :edit
    end
  end

  def destroy
    @product.photos.destroy_all
    @product.destroy
    redirect_to admin_products_path
  end

  private

  def product_params
    params.require(:product).permit(:title, :description, :quantity, :price, :photos, :category_id)
  end

  def find_product
    @product = Product.find(params[:id])
  end

end
