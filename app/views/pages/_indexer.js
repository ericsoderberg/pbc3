$(function() {
	$('#indexer').sortable({
		axis: "y",
		cursor: "move",
		update: function() {
	  	var orderVal =
	    	$('#indexer li').map(function(i, e){
	      	return $(e).attr('id')}).get().join(", ");
	  	$('#sub_order').val(orderVal);
		}
	});
});