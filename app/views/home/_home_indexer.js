$(function() {
	$('#home_indexer').sortable({
		axis: "y",
		cursor: "move",
		update: function() {
	  	var orderVal =
	    	$('#home_indexer li').map(function(i, e){
	      	return $(e).attr('id')}).get().join(", ");
	  	$('#home_feature_order').val(orderVal);
		}
	});
});
