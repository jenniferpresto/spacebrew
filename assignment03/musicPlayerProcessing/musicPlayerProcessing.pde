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

String guestName;
int knock;
int music;

void setup() {
  //  size(displayWidth, displayHeight);
  size(400, 200);
  sb = new Spacebrew( this );

  sb.addSubscribe("newGuest", "guestInfo");
  sb.addPublish("confirm", "boolean", false);

  sb.connect(server, name, description);
}

void draw() {
}

// this function not getting called, apparently
void onCustomMessage ( String name, String type, String value ) {
  println("received!");
  JSONObject arrival = JSONObject.parse( value );
  guestName = arrival.getString("arrivalName");
  knock = arrival.getInt("knock");
  music = arrival.getInt("music");

  println(guestName + " would like to enter to music " + str(music));

  sb.send("confirm", true );
}

