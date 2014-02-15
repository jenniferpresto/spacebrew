/* ***********************
 
 Collects information from web app indicating how guest would
 like to enter. Displays name and cues up appropriate
 theme music.
 
 Sends confirmation message back to web app.
 
 ************************ */


import spacebrew.*;

String server = "sandbox.spacebrew.cc";
String name="Processing side Custom Object Example";
String description = "Receiver; plays music on cue";

Spacebrew sb;

JSONObject instantConfirmation;

String guestName;
int knock;
int music;

void setup() {
  //  size(displayWidth, displayHeight);
  size(400, 200);
  sb = new Spacebrew( this );

  instantConfirmation = new JSONObject();

  sb.addSubscribe("newGuest", "guestinfo");
  sb.addPublish("confirmation", "confirmmessage", "\"r\":0, \"g\":0, \"b\":0");

  sb.connect(server, name, description);

  instantConfirmation.setInt("r", 100);
  instantConfirmation.setInt("g", 100);
  instantConfirmation.setInt("b", 100);
  
}

void draw() {
}

void onCustomMessage ( String name, String type, String value ) {
  println("received!");
  if ( type.equals("guestinfo") ) {
    println("in the if-statement");
    JSONObject arrival = JSONObject.parse( value );
    println("arrival object: " + arrival);
    guestName = arrival.getString("arrivalname");
    knock = arrival.getInt("knock");
    music = arrival.getInt("music");

    println("guustname: " + guestName + " knock: " + knock + " music: " + music);

    println(guestName + " would like to enter to music " + str(music));

    println("Let's see what we're sending: \n" + instantConfirmation.toString());
    sb.send("confirmation", "confirmmessage", instantConfirmation.toString());
  }
}

