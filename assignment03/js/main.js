/* ***********************

Collects information from form as to how guest would
like to enter. Sends information via JSON object to
Processing sketch, which sends back a confirmation.

If the person is in a line, then displays a timer
until that person can make his/her entrance.

Helpful code for timer available here:
http://stackoverflow.com/questions/1191865/code-for-a-simple-javascript-countdown-timer

************************ */

// wrapper so entire page loads before js implemented
window.onload = function () {

	var sb;
	var app_name = "guestAnnounceApp";

	function setup() {
		sb = new Spacebrew.Client({reconnect:true}); // what does reconnect part mean?

		sb.name = app_name;
		sb.description("Informs host how guest would like to enter");

		sb.addPublish ( "newGuest", "guestinfo", {arrivalname:"",knock:0,music:0} );
		sb.addSubscribe ( "confirmation", "confirmmessage" );
		sb.addSubscribe ( "waiting", "waitconfirm" );

		sb.onCustomMessage = onCustomMessage;

		// connect to Spacebrew
		sb.connect();

		// the guest name must be a global variable so that
		// it can be generated to send to Processing app and
		// then used to compare against what comes back
		var guestName = " ";
		var waitTime = 0.0; // will come from Processing app
		var counter; // used for timer
		var aboutToEnter = false; // used to send to final Welcome page at end

		// add button listener
		$('#submit').click (function (e) {
			// prevent refresh
			e.preventDefault(e);

			// collect information from the form on the first page
			guestName = $('#name').val();
			var selectedKnock = $('#knockList').val();
			var selectedMusic = $('#musicList').val();

			// create a pseudo JSON object;
			// this must be a string to arrive in the way that Processing can parse it
			var guest = "{\"arrivalname\": \"" + guestName + "\", \"knock\": " + selectedKnock + ", \"music\": " + selectedMusic + "}";
			// console.log(guest); // for debugging 

			sb.send( "newGuest", "guestinfo", guest );
		})

		// this function is called every time this app receives any message from the Processing app
		// via Spacebrew; the Processing app sends only custom messages.
		function onCustomMessage( name, value, type ){
			// incoming message contains information about that person's entrance
			// console.log(value); // uncomment if you want to see the raw information
			value = JSON.parse ( value );

			// Because all connected web apps will receive any message, we
			// only run these functions if responding to the relevant person.
			// Therefore must compare guest name to make sure it matches.
			if ( value.name == guestName ) {

				// round the waittime, which arrives from Processing
				// in the form of milliseconds, to seconds
				waitTime = Math.floor( value.waittime / 1000 );

				// this happens if the person can enter immediately...
				if (type == "confirmmessage") {
					// change the background color to match the Processing app
					// (chosen at random by the Processing app)
					document.body.style.backgroundColor="rgb(" + value.r + ", " + value.g + ", " + value.b + ")";
					// display the confirm page
					$("#nameEntry").addClass("hide");
					$("#pleaseWait").addClass("hide");
					$("#confirmed").removeClass("hide");

					// when confirmed to enter, change this to true,
					// so that app will show final screen when complete
					aboutToEnter = true;

				}

				// ...and this happens if the person must wait
				else if (type == "waitconfirm") {
					// hide the main page and show timer page
					// (at this point, the confirmation page is still hidden, so no need to change)
					$("#nameEntry").addClass("hide");
					$("#pleaseWait").removeClass("hide");
				}

				// same timer function is used whether the person is
				// waiting or entering
				counter = setInterval (countDownTimer, 1000);
			}
		}

		// timer uses global variable "waitTime," which is
		// set based on the messages received from the Processing app
		function countDownTimer() {
			waitTime -= 1;
			if ( waitTime <= 0 ) {
				clearInterval ( counter );
				// if person is entering, rather than waiting,
				// display final welcome screen
				if ( aboutToEnter ) {
					$("#confirmed").addClass("hide");
					$("#welcome").removeClass("hide");
				}
				return;
			}

			// display the timer on the web app
			document.getElementById("timer1").innerHTML = waitTime;
			document.getElementById("timer2").innerHTML = waitTime;
		}
	}

	// kick it all off with one function call
	setup();
}