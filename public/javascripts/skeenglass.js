$(function() {
	$("#slider").draggable({ containment: "parent", axis: 'x'});
	$('.photos').live('mouseover', function(){$(this).find('img').attr('src', '/images/camera_over.gif');});
	$('.photos').live('mouseout', function(){$(this).find('img').attr('src', '/images/camera_off.gif');});
	$('.photos').live('click', function(){
		$(this).parent().parent().find(".product_images a").colorbox({open: true});
	});
	$('.product_thumb').live('click', function(){
		$(this).siblings(".product_images a").colorbox({open: true});
	});
	
	var products = [
	                {Id: "22", Price: "12.00", Name: "Foo", Type: "bead", Thumb: "/images/beadthumb_1.jpg", Images: [{Title: "foo1", Filepath: "/images/big1.jpg", ProductId: 22}, 
	                                                                                          {Title: "", Filepath: "/images/big2.jpg", ProductId: 22}, 
	                                                                                          {Title: "", Filepath: "/images/big1.jpg", ProductId: 22}]},
	               ];
	//load product template and images
	$.get('/js/templates/productImagesTemplate.htm', function(template) {
			$.template("productImagesTemplate",template);
			$.get('/js/templates/productTemplate.htm', function(template) {
					$.template("productTemplate",template);
					 $("#products_grid_container").html($.tmpl( "productTemplate", products ));
			});
	});
});