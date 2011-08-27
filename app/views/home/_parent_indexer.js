$(function() {
	$('#parent_indexer').sortable({
		axis: "y",
		cursor: "move",
		update: function() {
	  	var orderVal =
	    	$('#parent_indexer li').map(function(i, e){
	      	return $(e).attr('id')}).get().join(", ");
	  	$('#parent_feature_order').val(orderVal);
		}
	});
});
