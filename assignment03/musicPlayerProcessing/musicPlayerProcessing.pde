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

  sb.addSubscribe("newGuest", "guestinfo");
  sb.addPublish("confirm", "boolean", false);

  // cut/pasted from Spacebrew examples
  sb.addSubscribe ("p5Point", "point2d");


  sb.connect(server, name, description);
}

void draw() {
}

void onCustomMessage ( String name, String type, String value ) {
  println("received!");
  //  String stringValue = str(value);
  if ( type.equals("guestinfo") ) {
    println("in the if-statement");
    JSONObject arrival = JSONObject.parse( value );
    println("dies here?");
    guestName = arrival.getString("arrivalName");
    knock = arrival.getInt("knock");
    music = arrival.getInt("music");

    println(guestName + " would like to enter to music " + str(music));

    sb.send("confirm", true );
  }

  // cut/pasted from Spacebrew examples
  if ( type.equals("point2d") ) {
    // parse JSON!
    JSONObject m = JSONObject.parse( value );
//    remotePoint.set( m.getInt("x"), m.getInt("y"));
    println("got it: " + m);
  }
}

