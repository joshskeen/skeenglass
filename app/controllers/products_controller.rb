class ProductsController < ApplicationController
  # GET /products
  # GET /products.xml
  def index
    @products = Product.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
      format.json  { 
        
        render :json => @products 
        
        }
    end
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/new
  # GET /products/new.xml
  def new
   @title = "New product"
   #puts "category id: #{params[:category_id].numeric}"
    @product = Product.new
    if params[:category_id]
        @category = Category.find(params[:category_id])
        @title =  @category.name + " > New product"
      @product.categories.push(@category)
    end
    @product_form_url = @category ? category_products_path(@category) : products_path(@product)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
    if params[:category_id]
      @category = Category.find(params[:category_id])
    end
    @product_form_url = @category ? category_product_path(@category, @product) : product_path(@product)
  end

  # POST /products
  # POST /products.xml
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        if(params[:category_id])
          @category = Category.find(params[:category_id])
        end
        format.html { 
          if @category
            redirect_to category_path(@category, :notice => 'Product was successfully added to ' + @category.name + '.')
          else
            redirect_to product_path(@product, :notice => 'Product was successfully created.')
          end
        }  
        format.xml  { render :xml => @product, :status => :created, :location => @product }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update
    @product = Product.find(params[:id])
    respond_to do |format|
      if @product.update_attributes(params[:product])
        if params[:category_id]
          @category = Category.find(params[:category_id])
          format.html { redirect_to(@category, :notice => 'Product was successfully updated.') }
        else
          format.html { redirect_to(@product, :notice => 'Product was successfully updated.') }            
        end
        
        
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to(products_url) }
      format.xml  { head :ok }
    end
  end
end
