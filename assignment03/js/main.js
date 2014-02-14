/* ***********************

Collects information from form as to how guest would
like to enter. Sends information via JSON object to
Processing sketch, which sends back a confirmation.

After confirmation sent and timer counts down, the app
closes itself.

************************ */

// wrapper so entire page loads before js implemented
window.onload = function () {

	var sb;
	var app_name = "JGP Custom Object - Kill Me Now";

	function setup() {
		sb = new Spacebrew.Client({reconnect:true}); // what does reconnect part mean?

		sb.name = app_name;
		sb.description("The barest bones of a Spacebrew app so far");

		sb.addPublish ( "newGuest", "guestInfo", {name:" ",knock:" ",music:" "} );
		sb.addSubscribe ( "confirm", "boolean", false );

		// connect to Spacebrew
		sb.connect();	// why does this go to spacebrew sandbox?

		// add button listener
		$('#submit').click (function (e) {
			// prevent refresh
			e.preventDefault(e);

			// collect information from the form on the first page
			var guestName = $('#name').val();
			var selectedKnock = $('#knockList').val();
			var selectedMusic = $('#musicList').val();

			console.log(guestName + " " + selectedKnock + " " + selectedMusic);
			// close();

			// create a JSON object 
			var guest = {
				name: guestName,
				knock: selectedKnock,
				music: selectedMusic
			}
		 

			sb.send( "newGuest", "guestInfo", guest );



		})

		function onBooleanMessage ( name, value ) {
			console.log("message received! and the answer is " + value );
		}

	}

	setup();

}