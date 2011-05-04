$(function() {
	$('#dynamic_form_fields').sortable({
		axis: "y",
		cursor: "move",
		update: function() {
			// strip "form_field_" prefix from each id to get list of ids
	  	var orderVal =
	    	$('#dynamic_form_fields li.form_field').map(function(i, e){
	      	return $(e).attr('id').substring(11)}).get().join(", ");
	  	$('#field_order').val(orderVal);
		}
	});
});