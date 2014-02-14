/* ***********************

Collects information from web app indicating how guest would
like to enter. Displays name and cues up appropriate
theme music.

Sends confirmation message back to web app.

************************ */


import spacebrew.*;

String server = "sandbox.spacebrew.cc";
String name="Custom Object Example";
String description = "Receiver; plays music on cue";

Spacebrew sb;

JSONObject newGuestInfo;

void setup() {
  newGuestInfo = new JSONObject();
}

void draw() {
}
