// wrapper so entire page loads before js implemented
window.onload = function () {

	$(document).click(function(e) {
		console.log("clicking!");
		$('#container').removeClass('hide');
	})

}