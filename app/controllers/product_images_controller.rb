class ProductImagesController < ApplicationController
  # GET /product_images
  # GET /product_images.xml
  def index
    @product_images = ProductImage.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @product_images }
    end
  end

  # GET /product_images/1
  # GET /product_images/1.xml
  def show
    @product_image = ProductImage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product_image }
    end
  end

  # GET /product_images/new
  # GET /product_images/new.xml
  def new
    logger.debug("hello from product_images new")
    logger.debug(params)
    @product = Product.find(params[:product_id])
    
    @product_image = @product.product_images.build
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product_image }
    end
  end

  # GET /product_images/1/edit
  def edit
    @product_image = ProductImage.find(params[:id])
  end

  # POST /product_images
  # POST /product_images.xml
  def create
    #@product_image = ProductImage.new(params[:product_image])
    @product = Product.find(params[:product_id])
    @product_image = @product.product_images.build(params[:product_image])
    
    respond_to do |format|
      if @product_image.save
        
        format.html { redirect_to(@product_image.product, :notice => 'Product image was successfully created.') }
        
        format.xml  { render :xml => @product_image, :status => :created, :location => @product_image }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product_image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /product_images/1
  # PUT /product_images/1.xml
  def update
    @product_image = ProductImage.find(params[:id])

    respond_to do |format|
      if @product_image.update_attributes(params[:product_image])
        format.html { redirect_to(@product_image, :notice => 'Product image was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product_image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /product_images/1
  # DELETE /product_images/1.xml
  def destroy
    @product_image = ProductImage.find(params[:id])
    @product = @product_image.product
    @product_image.destroy

    respond_to do |format|
      format.html { 
            redirect_to(@product, :notice => 'Product image deleted.') 
        }
      format.xml  { head :ok }
    end
  end
end
