/* ***********************

Collects information from form as to how guest would
like to enter. Sends information via JSON object to
Processing sketch, which sends back a confirmation.

If the person is in a line, then displays a timer
until that person can make his/her entrance.

After confirmation sent and timer counts down, the app
closes itself.

Helpful code for timer available here:
http://stackoverflow.com/questions/1191865/code-for-a-simple-javascript-countdown-timer

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
		sb.addSubscribe ( "waiting", "waitconfirm" );

		sb.onCustomMessage = onCustomMessage;

		// connect to Spacebrew
		sb.connect();	// why does this go to spacebrew sandbox?

		// the guest name must be a global variable so that
		// it can be generated to send to Processing app and
		// used to compare against what comes back
		var guestName = " ";
		var waitTime = 0.0;
		var counter;
		var aboutToEnter = false;

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
			value = JSON.parse ( value );
			console.log("saved guestName is :" + guestName + "and wait time is " + waitTime);

			// only run these functions if responding to the same person
			if ( value.name == guestName ) {

				// change waitTime variable only if the names match
				waitTime = Math.floor( value.waittime / 1000 );

				if (type == "confirmmessage") {
					document.body.style.backgroundColor="rgb(" + value.r + ", " + value.g + ", " + value.b + ")";
					$("#nameEntry").addClass("hide");
					$("#pleaseWait").addClass("hide");
					$("#confirmed").removeClass("hide");

					aboutToEnter = true;

				} else if (type == "waitconfirm") {
					// again, change webpage of only the relevant guest
					console.log ("getting wait message, and the info is ", value );
						// hide the main page and show timer page
					$("#nameEntry").addClass("hide");
					$("#pleaseWait").removeClass("hide");

					console.log("total time: " + waitTime);
				}

				counter = setInterval (countDownTimer, 1000);
			}
		}

		function countDownTimer() {
			console.log("calling timer");
			waitTime -= 1;
			if ( waitTime <= 0 ) {
				clearInterval ( counter );
				if ( aboutToEnter ) {
					$("#confirmed").addClass("hide");
					$("#welcome").removeClass("hide");
				}
				return;
			}
			document.getElementById("timer1").innerHTML = waitTime;
			document.getElementById("timer2").innerHTML = waitTime;
			// don't know what's wrong with JQuery
			// $("#timer1").html = waitTime ;
			// $("#timer2").html = waitTime ;
		}
	}


	setup();

}