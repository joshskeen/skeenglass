var category_data = {};
    category_data.beads = {};
    category_data.beads.id = 1;
    category_data.beads.items_per_page = 10;
    category_data.pendants = {};
    category_data.pendants.id = 2;
    category_data.necklaces = {};
    category_data.necklaces.id = 3;

var current_category;
var current_page;
var current_data;

$(function() {
	$("#slider").draggable({ containment: "parent", axis: 'x'});
	$('.photos').live('mouseover', function(){$(this).find('img').attr('src', '/images/camera_over.gif');});
	$('.photos').live('mouseout', function(){$(this).find('img').attr('src', '/images/camera_off.gif');});
	$('.photos').live('click', function(){$(this).parent().parent().find(".product_images a").colorbox({open: true});});
	$('.product_thumb').live('click', function(){
		$(this).siblings('.product_images').find('a').colorbox({open: true});
	});
	

var app = $.sammy(function() {
    this.element_selector = "body";
    this.get('#/:category_name/:page', function(){
        displayLoader();
         var category_name = this.params['category_name'];
         var page = this.params['page'];
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
                             $("#pager .page_" + page).addClass('active');
                             
            });
         });
    });
  });
  });
  $(function() {
    app.run('#/beads/1');
  });
});

function displayLoader(){
  $("#pager").append("loading..");
}


function addPagerLinks(pages, category_name){
  if(isNaN(pages)){
      $("#pager").html("no products.");
  }else{
      $("#pager").html("pages:");
      for(var i = 1; i < pages + 1; i++){
          var html = "<a class='page_"+i+"' href='/#/"+category_name+"/" + i + "'>" + i + "</a>";
          $("#pager").append(html);
      }
  }
}
