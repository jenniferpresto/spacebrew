##Announce Yourself
####App allowing guests to announce their arrival

This is a two-part app that allows guests to enter a party while their chosen form of theme music plays. Guests connect via a web app, which communicates with the party host's Processing app.

The web app alerts Processing to the guests' arrivals, and Processing queues any waiting guests and plays the appropriate knock and theme music at the appropriate time.

####Components
The included items are as follows:

* **index.html** is the primary web page
* **js** folder includes the main javascript app, main.js, as well as the Spacebrew and JQuery libraries.
* **css** contains the stylesheet for the web app.
* **iTunesPause.app** and **iTunesPlay.app** are short AppleScripts that pause and restart iTunes. These executable apps are called by Processing during the application.
* **musicPlayerProcessing** contains the Processing app and its data, including all the sound clips.