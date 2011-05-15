$(function() {
	$('#indexer').sortable({
		axis: "y",
		cursor: "move",
		update: function() {
	  	var orderVal =
	    	$('#indexer li').map(function(i, e){
	      	return $(e).attr('id')}).get().join(", ");
	  	$('#feature_order').val(orderVal);
		}
	});
});
