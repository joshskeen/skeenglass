require 'google4r/checkout'
class ProductsController < ApplicationController
  # GET /products
  # GET /products.xml
  before_filter :authenticate_user!, :except => [:add_to_cart, :cart_items, :checkout]
  @@configuration = { :merchant_id => '119277627551780', :merchant_key => '4Jwx3ZkSmI_h_rpqePpQYQ', :use_sandbox => true }
   
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
  
  def cart_items
    if request.xhr?
    @ids = params[:ids].split(',')
    @products = Product.find(@ids)
    render :json => @products 
    else
      head :bad_request
    end
  end

  def add_to_cart
    if request.xhr?
      @product = Product.find(params[:id])
      if @product.in_cart == true
        render :json => {:status => 'fail', :message => 'item is already in someone elses cart!'}.to_json
      else
        @product.in_cart = true;
        @product.save
        if @product.save
          render :json => {:status => 'success', :message => 'item added to cart!'}.to_json
        else 
          render :json => @product.errors, :status => :unprocessable_entity
        end
      end
    else
      head :bad_request
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
  
  
  def checkout
    @products = Product.find(params[:ids].split(','))
         @frontend = Google4R::Checkout::Frontend.new(@@configuration)
         checkout_command = @frontend.create_checkout_command
         @products.each do |product|
           checkout_command.shopping_cart.create_item do|item|
             item.id = product.id
             item.name = product.name
             result = []
              product.categories.each do | cat |
                result << cat.name
              end
             item.description = result.join(',')
             item.unit_price = Money.new(product.price*100, "USD")
             item.quantity = 1
           end  
         end
      checkout_command.create_shipping_method(Google4R::Checkout::FlatRateShipping) do |shipping_method|
        shipping_method.name = "UPS Standard 3 Day"
        shipping_method.price = Money.new(500, "USD")
      end
      
    response = checkout_command.send_to_google_checkout
    logger.debug(response)
    #logger.debug(response.message)
    logger.debug(response.serial_number)
    @order = Order.create(:serial_number => response.serial_number)
    @order.products = @products
    @order.save
    redirect_to response.redirect_url
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
