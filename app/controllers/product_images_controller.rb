class ProductImagesController < AdminController
  before_action :find_product, only: [:index, :new, :create, :edit, :update]

  def index
    @product_image = ProductImage.all
  end

  def new
    @product_image = ProductImage.new
  end

  def create
    @product_image = ProductImage.new(product_image_params)
    @product_image.product = @product
    if @product_image.save
      flash[:notice] = "上传高清图片成功"
      redirect_to edit_admin_product_path(@product)

    else
      flash[:alert] = "上传失败"
      render :new
    end
  end

  def edit
    @product_image = ProductImage.find(params[:id])
  end

  def update

    if params[:big_image] != nil
        @product.product_images.destroy_all #need to destroy old pics first
    end

    @product_image = ProductImage.find(params[:id])
    @product_image.product = @product

    if @product_image.update(product_image_params)
      flash[:notice] = "上传高清图片成功"
      redirect_to edit_admin_product_path(@product)
    else
      flash[:alert] = "上传失败"
      render :edit
    end
  end

  private

  def product_image_params
    params.require(:product_image).permit(:big_image, :product_id)
  end

  def find_product
    @product = Product.find(params[:product_id])
  end

end
