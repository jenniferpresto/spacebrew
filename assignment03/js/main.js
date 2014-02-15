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

		sb.addPublish ( "newguest", "guestinfo", {arrivalname:"",knock:0,music:0} );

		// cut/pasted from Spacebrew examples
		sb.addPublish( "point", "point2d", {x:0,y:0} );

		sb.addSubscribe ( "confirm", "boolean", false );

		// connect to Spacebrew
		sb.connect();	// why does this go to spacebrew sandbox?

		// add button listener
		$('#submit').click (function (e) {
			// prevent refresh
			e.preventDefault(e);

			// collect information from the form on the first page
			var guestname = $('#name').val();
			var selectedknock = $('#knockList').val();
			// var selectedKnockInt = parseInt(selectedKnock); // necessary?
			var selectedmusic = $('#musicList').val();
			// var selectedMusicInt = parseInt(selectedMusic); // necessary?

			console.log(guestname + " " + selectedknock + " " + selectedmusic);
			// close();

			// create a JSON object 
			// var guest = {arrivalname:guestname, knock:selectedknock, music:selectedmusic};
			// var guest = {arrivalname:"guestname", knock:"selectedknock", music:"selectedmusic"};
			// var guest = {arrivalname:"1", knock:1, music:1};
			var guest = "{arrivalname:\"this is a string!\", knock:1, music:1}";

			console.log(guest);		 

			sb.send( "newguest", "guestinfo", guest );

			// cut/pasted from Spacebrew examples
			// var mouse = {x:0, y:1};
			// sb.send("point", "point2d", mouse);  


		})

		function onBooleanMessage ( name, value ) {
			console.log("message received! and the answer is " + value );
		}

	}

	setup();

}