var category_data = {};
category_data.beads = {};
category_data.beads.id = 1;
category_data.beads.items_per_page = 10;
category_data.pendants = {};
category_data.pendants.id = 2;
category_data.necklaces = {};
category_data.necklaces.id = 3;
var store;
var current_category;
var current_page;
var current_data;


$(function() {
    
    
    
    $("#slider").draggable({ containment: "parent", axis: 'x'});
    $('.photos').live('mouseover', function(){$(this).find('img').attr('src', '/images/camera_over.gif');});
    $('.photos').live('mouseout', function(){$(this).find('img').attr('src', '/images/camera_off.gif');});
    $('.photos').live('click', function(){
        $(this).parent().parent().find(".product_images a").colorbox({open: true });
        var product_id = $(this).parent().parent().attr('id').replace('product_', '');
        $('<a href="/#/add_to_cart/'+product_id+'" id="add_to_cart" class="'+product_id+'" style="position:absolute; top:0;right:0px;cursor:pointer; background:#8cb3a0; color:#fff;padding:5px;">Add to cart</a>').appendTo('#cboxContent'); 
    }); 
    $('.product_thumb').live('click', function(){
        var product_id = $(this).parent().attr('id').replace('product_', '');
        $(this).siblings('.product_images').find('a').colorbox({open: true});
        $('<a href="/#/add_to_cart/'+product_id+'" id="add_to_cart" class="'+product_id+'" style="position:absolute; top:0;right:0px;cursor:pointer; background:#8cb3a0; color:#fff;padding:5px;">Add to cart</a>').appendTo('#cboxContent'); 
    });
     $('.product_thumb_checkout').live('click', function(){
         $("#add_to_cart").remove();
        $(this).parent().parent().find('.product_images').find('a').colorbox({open: true});
    });


    app = $.sammy(function() {
        this.element_selector = "body";
        this.get('#/checkout', function(context){
            $("nav a").removeClass('active');
           $("#scrollbar_area .inner").hide();
           $("#pager").hide();
           checkout();
        });
        
        this.get('#/process_checkout', function(context){
            var cart_item_ids = getCartItems().join(',');
            context.redirect('/products/checkout/'+cart_item_ids);
        });
        
        
        this.get('#/remove/:product_id', function(context){
           var product_id = this.params['product_id'];
           var cart_items = getCartItems();
           var idx = cart_items.indexOf(product_id);
           if(idx != -1 && cart_items.length > 1){
             cart_items.splice(idx, 1);
             store.set('cart_items', cart_items.join(','));
           }else if(cart_items.length == 1 && (cart_items[0] == product_id || cart_items[0] == product_id)){
            //   store.set('cart_items', '');
               //store.clearAll();
               store.clear('cart_items');
           } 
            $.notifyBar({
                      cls: "success",
                      html: "Item removed from cart.",
                      delay: 1000,
                      animationSpeed: "normal"
            });
            getCartItemsTotal();
            context.redirect('#/checkout');
           }
        );
    
    
        this.get('#/add_to_cart/:product_id', function(context){
            var product_id = this.params['product_id'];
            $.ajax({
                url: '/products/add_to_cart/' + product_id,
                success: function(response){
                    //console.log(response);
                    $.colorbox.close();
                    storeCartItem(product_id);
                    getCartItemsTotal();
                    context.redirect('#/'+current_category+'/'+current_page);
                        $.notifyBar({
                          cls: "success",
                          html: "Item added to cart.",
                          delay: 1000,
                          animationSpeed: "normal"
                        });
                }
            });
        });
    
    
        this.get('#/:category_name/:page', function(context){
            //$("#scrollbar_area .inner").show();
            store = new Sammy.Store.Cookie({name: 'skeenglass_cart', type: 'cookie'});
            $("#products_grid_container").empty();
            displayLoader();
            var category_name = this.params['category_name'];
            var page = this.params['page'];
            current_page = page > 0 ? page : 1;
            current_category = category_name;
            var category_config = category_data[category_name];
            var data_url = '/categories/'+ category_config.id +'.json';
            $.get(data_url, function(response){
                $("nav a").removeClass('active');
                $("#nav_" + category_name).addClass('active');
                $.get('/javascripts/templates/productImagesTemplate.htm', function(template) {
                    $.template("productImagesTemplate",template);
                    $.get('/javascripts/templates/productTemplate.htm', function(template) {
                        $.template("productTemplate",template);   
                        var products = $.tmpl( "productTemplate", response.products ).addClass(category_name);
                        var page_slice = (products.slice(((page - 1) * category_config.items_per_page), (category_config.items_per_page*page)));
                        $("#products_grid_container").html(page_slice);
                        var pages = Math.ceil(products.length / category_config.items_per_page);
                        addPagerLinks(pages, category_name);
                        if(pages < current_page){
                            current_page = pages > 0 ? pages : 1;
                            context.redirect('#/'+current_category+'/'+current_page);
                        }
                        $("#pager .page_" + page).addClass('active');
                    });
                });
            });
        });

    });

    $(function() {
      getCartItemsTotal();
        app.run('#/beads/1');
    });
});

function displayLoader(){
    $("#pager").append("&nbsp;<img src='/images/ajax-loader.gif' />&nbsp;loading..");
}

function storeCartItem(product_id){
    items_in_cart = getCartItems();               
    items_in_cart.push(product_id);
    store.set('cart_items', items_in_cart.join(','));
}

function getCartItems(){
    store = new Sammy.Store.Cookie({name: 'skeenglass_cart', type: 'cookie'});
    var cart_items = store.get('cart_items');
    if(cart_items == null){
        items_in_cart = new Array();
    }else{
        if(typeof(cart_items) == 'number'){
            items_in_cart = new Array();
            items_in_cart.push(cart_items);
        }else{
            items_in_cart = cart_items.split(/,/);    
        }
    }
    return items_in_cart;
}


function checkout(){
    var cart_template = '';
    cart_item_ids = getCartItems().join(',');
    if(cart_item_ids.length > 0){
         $.get('/javascripts/templates/productImagesTemplate.htm', function(template) {
            $.template("productImagesTemplate",template);    
         });
         $.get('/javascripts/templates/productCartTemplate.html', function(template) { 
          cart_template = template;
         });
          $.get('/javascripts/templates/productTemplateTable.html', function(template) {
          $.template("productTemplateTable",template);  
         });
         
        $.ajax({
            url: "/products/cart_items/" + cart_item_ids,
            success: function(response){
                item_count = 0;
                price_total = 0;
                $(response).each(function(){
                    item_count++;
                    price_total += this.price;
                    
                });
                $("#products_grid_container").html(cart_template);
                $("#cart_template .products table").html("<tr><th></th><th>Product</th><th>Price</th></tr>");
                $("#cart_template .products table").append($.tmpl( "productTemplateTable", response));
                $(".subtotal_price").html(price_total + "$");
                
            }
        }); 
    }else{
        $("#products_grid_container").html("<p>No items in cart</p>");
    }
}

function getCartItemsTotal(){
    var cart_item_ids = getCartItems().join(',');
    if(cart_item_ids.length > 0){
        $.ajax({
            url: "/products/cart_items/" + cart_item_ids,
            success: function(response){
                item_count = 0;
                price_total = 0;
                $(response).each(function(){
                    item_count++;
                    price_total += this.price;
                });
                $(".checkout_link").show();
                var item_text = "items";
                if(item_count == 1){
                    item_text = "item";
                }
                $(".checkout_link").show();
                $(".item_count .total_price").html(price_total + "$");
                $(".item_count .number_items").html(item_count + "&nbsp;" + item_text);
            }
        });
    }else{
        $(".item_count .total_price").html("");
         $(".item_count .number_items").html("no items in cart");
        $(".checkout_link").hide();
    }
}


function addPagerLinks(pages, category_name){
    $("#pager").show();
    if(isNaN(pages) || pages == 0){
        $("#pager").html("no products.");
    }else{
        $("#pager").html("pages:");
        for(var i = 1; i < pages + 1; i++){
            var html = "<a class='page_"+i+"' href='/#/"+category_name+"/" + i + "'>" + i + "</a>";
            $("#pager").append(html);
        }
    }
}
