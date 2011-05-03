$(function() {
	$('#dynamic_form_fields').sortable({
		axis: "y",
		cursor: "move",
		update: function() {
			// strip "ff_" prefix from each id to get list of ids
	  	var orderVal =
	    	$('#dynamic_form_fields li.dynamic_form_field').map(function(i, e){
	      	return $(e).attr('id').substring(3)}).get().join(", ");
			alert(orderVal);
	  	$('#field_order').val(orderVal);
		}
	});
});