/* ***********************
 
 Collects information from web app indicating how guest would
 like to enter. Displays name and cues up appropriate
 theme music.
 
 Sends confirmation message back to web app.
 
 Jennifer Presto
 Parsons MFA-DT, Spacebrew Collab
 February 18, 2014
 
 Credit where credit's due:
 
 Record scratch sound:
 http://www.youtube.com/watch?v=4uQ2P0xgenw
 Door knocking sound:
 http://www.youtube.com/watch?v=CNZDm_zKCIo
 Whistle sound from here:
 http://www.youtube.com/watch?v=mYpmyE1fliE
 Gong sound from here:
 http://www.youtube.com/watch?v=eg7NXRJwYXs
 
 Also Sprach Zarathustra from here:
 http://www.youtube.com/watch?v=QwxYiVXYyVs
 Imperial march from here:
 http://www.youtube.com/watch?v=-bzWSJG93P8
 Circus music from here:
 http://www.youtube.com/watch?v=HAa8aICcZqA&list=PLC669C97ADC22682F&index=3
 
 ************************ */

// Audio
import ddf.minim.*;

Minim minim;
AudioPlayer[] knocks = new AudioPlayer[3];
AudioPlayer[] entranceClips = new AudioPlayer[3];

// Spacebrew
import spacebrew.*;
String server = "sandbox.spacebrew.cc";
String name="HostSideAnnounceApp";
String description = "Receiver; plays music on cue";
Spacebrew sb;

// info to receive from web app
String guestName = "";
int knockIndex = 0;
int musicIndex = 0;

// info to send to web app
JSONObject instantConfirmation; // if the person is first in line
JSONObject waitConfirmation; // if there'll be a wait
ArrayList<JSONObject> waitlist; // used only if multiple people entering at once

// executables to stop/start iTunes player
String iTunesPlayApp;
String iTunesPauseApp;

// variables for display
PFont centuryGothic;
color bgColor = color(0, 0, 0);
int red, green, blue;

// variables for timing audio
boolean bEntranceInProgress = false;
boolean bKnockingStarted = false;
boolean bMusicStarted = false;
boolean biTunesRestarted = false;
int entranceStartTime = 0;

void setup() {
  //  size(displayWidth, displayHeight);
  size(800, 600); // for debugging
  minim = new Minim( this );
  sb = new Spacebrew( this );

  // load up the various sound clips
  knocks[0] = minim.loadFile("knocking.mp3");
  knocks[1] = minim.loadFile("whistle.mp3");
  knocks[2] = minim.loadFile("gong.mp3");
  entranceClips[0] = minim.loadFile("alsoSprachZarathustra.mp3");
  entranceClips[1] = minim.loadFile("imperialMarchClip.aif");
  entranceClips[2] = minim.loadFile("clowns.mp3");

  // create JSON object that will be sent upon instant notification
  instantConfirmation = new JSONObject();
  instantConfirmation.setString("name", "");
  instantConfirmation.setInt("r", 100);
  instantConfirmation.setInt("g", 100);
  instantConfirmation.setInt("b", 100);

  // create JSON object that will be sent when person must wait
  waitConfirmation = new JSONObject();
  waitConfirmation.setString("name", "");
  waitConfirmation.setInt("waittime", 10000);

  waitlist = new ArrayList<JSONObject>();

  sb.addSubscribe("newGuest", "guestinfo");
  sb.addPublish("confirmation", "confirmmessage", "\"name\":\"\", \"r\":0, \"g\":0, \"b\":0, \"waittime\": 0");
  sb.addPublish("waiting", "waitconfirm", "\"name\":\"\", \"waittime\":10000");

  sb.connect(server, name, description);

  iTunesPlayApp = "/Users/SandlapperNYC/Developer/SpacebrewClass/SpacebrewRepo/assignment03/iTunesPlay.app";
  iTunesPauseApp = "/Users/SandlapperNYC/Developer/SpacebrewClass/SpacebrewRepo/assignment03/iTunesPause.app";

  centuryGothic = loadFont("CenturyGothic-Bold-64.vlw");
  textFont(centuryGothic);
  textAlign(CENTER, CENTER);
}

void draw() {
  // most of the time, the app shows only a black screen
  background(0);

  // when someone activates the web app, begin the process of
  // playing the appropriate knock and music, with a
  // three-second delay between them.

  if (bEntranceInProgress) {
    // change the background color to the same one showing on the web app,
    // which gets randomly selected when the person first enters his/her information
    background(bgColor);
    // display guest's name
    text(guestName, width/2, height/2);

    // The following if-else statements are divided into four parts, 
    // each of which gets called for one frame. 
  
    // first, stop iTunes, play knock immediately, and start the timer
    if ( !bKnockingStarted ) {
      open( iTunesPauseApp );
      entranceStartTime = millis();
      knocks[knockIndex].play();
      bKnockingStarted = true;
    }
    
    // second part kicks in after the knock is complete, plus three seconds
    else if (millis() > entranceStartTime + knocks[knockIndex].length() + 3000 && !bMusicStarted) {
      entranceClips[musicIndex].play();
      bMusicStarted = true;
    }
    
    // third part restarts iTunes after the theme music has ended (plus 1/10th of a second)
    // also rewinds the clips that were just played
    else if (millis() > entranceStartTime + knocks[knockIndex].length() + 3000 + entranceClips[musicIndex].length() + 100 && !biTunesRestarted ) {
      open(iTunesPlayApp);
      knocks[knockIndex].rewind();
      entranceClips[musicIndex].rewind();
      biTunesRestarted = true;
    }
    
    // fourth and last part makes sure there's a 10-second buffer before next person can be announced
    //  resets all boolean variables to false
    else if ( millis() > entranceStartTime + knocks[knockIndex].length() + entranceClips[musicIndex].length() + 13000 ) {
      bEntranceInProgress = false;
      bKnockingStarted = false;
      bMusicStarted = false;
      biTunesRestarted = false;
    }
  }

  // if there is no entrance in progress, check to see if there are people on the waitlist
  // if so, execute similar function to the immediate confirmation
  else if ( waitlist.size() > 0 ) {
    JSONObject g = (JSONObject)waitlist.get(0);
    guestName = g.getString("name");
    knockIndex = g.getInt("chosenKnock");
    musicIndex = g.getInt("chosenMusic");
    red = g.getInt("r");
    green = g.getInt("g");
    blue = g.getInt("b");

    // once we have the information we need, delete that person from the waitlist
    waitlist.remove(0);

    packageSendEntrance();
  }
}

// this function is called when app receives a message from the web app via Spacebrew
void onCustomMessage ( String name, String type, String value ) {
  if ( type.equals("guestinfo") ) {
    JSONObject arrival = JSONObject.parse( value );
    println("arrival object: " + arrival);

    // pick a random color (on the dark side of the spectrum)
    red = int(random(150));
    green = int(random(150));
    blue = int(random(150));

    // if no one is currently entering, we'll send confirmation immediately
    // and start the entrance
    if ( !bEntranceInProgress ) {
      guestName = arrival.getString("arrivalname");
      knockIndex = arrival.getInt("knock");
      musicIndex = arrival.getInt("music");

      packageSendEntrance();
    }

    // but if someone is already making his/her entrance,
    // add all the new person's information to an ArrayList and send
    // the wait time instead
    else {
      waitlist.add(new JSONObject());
      JSONObject latestInfo = waitlist.get( waitlist.size() - 1 ); // get the last one; the empty one we just added
      latestInfo.setString("name", arrival.getString("arrivalname") );
      latestInfo.setInt("r", red);
      latestInfo.setInt("g", green);
      latestInfo.setInt("b", blue);
      latestInfo.setInt("chosenKnock", arrival.getInt("knock") );
      latestInfo.setInt("chosenMusic", arrival.getInt("music"));
      println("new waitlist object: \n" + latestInfo);
      println("size of the waitlist: " + waitlist.size());

      // figure out long this person will have to wait
      int estimatedWaitTime = 0;
      // add the amount of time left in the current announcement
      estimatedWaitTime += (entranceStartTime + knocks[knockIndex].length() + entranceClips[musicIndex].length() + 13000) - millis();
      println("this much time left: " + estimatedWaitTime);

      // then add up times for all people on the waitlist ahead of this person
      for (int i = 0; i < waitlist.size() - 1; i++) {
        JSONObject g = (JSONObject) waitlist.get(i);
        estimatedWaitTime += knocks[g.getInt("chosenKnock")].length(); // add the length of the chosen knock
        estimatedWaitTime += entranceClips[g.getInt("chosenMusic")].length(); // add the length of the chosen music
        estimatedWaitTime += 13000; // add 13 seconds (time between knock and music, plus 10 seconds after)
      }

      // then send the person's name back to him/her, along with the estimated wait time
      waitConfirmation.setString("name", arrival.getString("arrivalname") );
      waitConfirmation.setInt("waittime", estimatedWaitTime);

      println("estimated wait time: " + estimatedWaitTime);

      sb.send( "waiting", "waitconfirm", waitConfirmation.toString() );
    }
  }
}

void packageSendEntrance() {
  // change background color to random color
  bgColor = color(red, green, blue);

  // send that color to the web app,
  // along with name to make sure they match
  instantConfirmation.setString("name", guestName);
  instantConfirmation.setInt("r", red);
  instantConfirmation.setInt("g", green);
  instantConfirmation.setInt("b", blue);
  instantConfirmation.setInt("waittime", knocks[knockIndex].length() + 3000 );

  sb.send( "confirmation", "confirmmessage", instantConfirmation.toString() );

  bEntranceInProgress = true;
}

