/* ***********************
 
 Collects information from web app indicating how guest would
 like to enter. Displays name and cues up appropriate
 theme music.
 
 Sends confirmation message back to web app.
 
 Jennifer Presto
 Parsons MFA-DT, Spacebrew Collab
 February 18, 2014
 
 ************************ */

// Audio
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

// Spacebrew
import spacebrew.*;
String server = "sandbox.spacebrew.cc";
String name="ProcessingObjectApp";
String description = "Receiver; plays music on cue";
Spacebrew sb;

// info to send to web app
JSONObject instantConfirmation;

// info to receive from web app
String guestName = "";
int knockIndex;
int musicIndex;

// executables to stop/start iTunes player
String iTunesPlayApp;
String iTunesPauseApp;

PFont centuryGothic;
color bgColor = color(0, 0, 0);

void setup() {
  //  size(displayWidth, displayHeight);
  size(800, 600);
  sb = new Spacebrew( this );

  instantConfirmation = new JSONObject();
  instantConfirmation.setString("name", "");
  instantConfirmation.setInt("r", 100);
  instantConfirmation.setInt("g", 100);
  instantConfirmation.setInt("b", 100);

  sb.addSubscribe("newGuest", "guestinfo");
  sb.addPublish("confirmation", "confirmmessage", "\"name\":\"\", \"r\":0, \"g\":0, \"b\":0");

  sb.connect(server, name, description);

  iTunesPlayApp = "/Users/SandlapperNYC/Developer/SpacebrewClass/SpacebrewRepo/assignment03/iTunesPlay.app";
  iTunesPauseApp = "/Users/SandlapperNYC/Developer/SpacebrewClass/SpacebrewRepo/assignment03/iTunesPause.app";

  centuryGothic = loadFont("CenturyGothic-Bold-64.vlw");
  textFont(centuryGothic);
  textAlign(CENTER, CENTER);
}

void draw() {
  background(bgColor);
  text(guestName, width/2, height/2);
}

void onCustomMessage ( String name, String type, String value ) {
  println("received!");
  if ( type.equals("guestinfo") ) {
    println("in the if-statement");
    JSONObject arrival = JSONObject.parse( value );
    println("arrival object: " + arrival);
    guestName = arrival.getString("arrivalname");
    knockIndex = arrival.getInt("knock");
    musicIndex = arrival.getInt("music");

    println("Name of guest: " + guestName + " knock: " + knockIndex + " music: " + musicIndex);

    println(guestName + " would like to enter to music " + str(musicIndex));

    // pick a random color
    int red = int(random(255));
    int green = int(random(255));
    int blue = int(random(255));

    // send that color to the web app,
    // along with name to make sure they match
    instantConfirmation.setString("name", guestName);
    instantConfirmation.setInt("r", red);
    instantConfirmation.setInt("g", green);
    instantConfirmation.setInt("b", blue);

    println("Let's see what we're sending: \n" + instantConfirmation.toString());
    sb.send("confirmation", "confirmmessage", instantConfirmation.toString());

    // change background color here to same color
    bgColor = color(red, green, blue);
  }
}

void mousePressed() {
  println("calling mousePressed function");
  //  open("/Users/SandlapperNYC/Developer/SpacebrewClass/SpacebrewRepo/assignment03/iTunesPlaypause.app");
  open(iTunesPlayApp);
}

void keyPressed() {
  println("calling keyPressed");
  open(iTunesPauseApp);
}

