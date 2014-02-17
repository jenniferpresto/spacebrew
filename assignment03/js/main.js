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

		sb.addPublish ( "newGuest", "guestinfo", {arrivalname:"",knock:0,music:0} );
		sb.addSubscribe ( "confirmation", "confirmmessage" );
		sb.addSubscribe ( "waiting", "waittime" );

		sb.onCustomMessage = onCustomMessage;

		// connect to Spacebrew
		sb.connect();	// why does this go to spacebrew sandbox?

		// the guest name must be a global variable so that
		// it can be generated to send to Processing app and
		// used to compare against what comes back
		var guestName = " ";
		var waitTime = 0.0;

		// add button listener
		$('#submit').click (function (e) {
			// prevent refresh
			e.preventDefault(e);

			// collect information from the form on the first page
			guestName = $('#name').val();
			var selectedKnock = $('#knockList').val();
			var selectedMusic = $('#musicList').val();

			console.log(guestName + " " + selectedKnock + " " + selectedMusic);

			// create a pseudo JSON object;
			// must be a string to arrive in the way that Processing expects it

			var guest = "{\"arrivalname\": \"" + guestName + "\", \"knock\": " + selectedKnock + ", \"music\": " + selectedMusic + "}";
			console.log(guest);		 

			sb.send( "newGuest", "guestinfo", guest );
		})

		function onCustomMessage( name, value, type ){
			console.log(value);
			if (type == "confirmmessage") {
				value = JSON.parse( value );
				console.log("saved guestName is :" + guestName);
				// change the background only if the name you get back is the same one you sent
				document.body.style.backgroundColor="rgb(" + value.r + ", " + value.g + ", " + value.b + ")";
			}

			if (type == "waittime") {
				// value = JSON.parse( value );
				// console.log("The wait time is " + value;

			}
		}
	}


	setup();

}