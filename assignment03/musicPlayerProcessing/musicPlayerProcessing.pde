/* ***********************

Collects information from web app indicating how guest would
like to enter. Displays name and cues up appropriate
theme music.

Sends confirmation message back to web app.

************************ */


import spacebrew.*;

String server = "sandbox.spacebrew.cc";
String name="JGP Custom Object Example";
String description = "Receiver; plays music on cue";

Spacebrew sb;

JSONObject newGuestInfo;

String name;
String knock;
String music;

void setup() {
//  size(displayWidth, displayHeight);
  size(200, 400);
  sb = new Spacebrew( this );
  
  sb.addSubscribe("newGuest", "guestInfo");
  sb.addPublish("confirm", "boolean", false);
  
  sb.connect(server, name, description);
}

void draw() {
}

void onCustomMessage ( String name, String type, String value ) {
  JSONObject arrival = JSONObject.parse( value );
  name = arrival.getString("name");
  
}
