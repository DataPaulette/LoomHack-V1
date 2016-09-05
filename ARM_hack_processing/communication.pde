/*
This sketch read pixels from an array to control a LED ribbon of WS2812
 Copyright (C) 2016 Maurin Donneaud - maurin@datapaulette.org
 It use Processing 3.0
 */
char HEADER     = 64;        // header recived evrey knetted row 
char FOOTER     = 255;       // footer to terminate the list of pixels to knit
int PIXELWIDTH  = 0;         // 
int PIXELHEIGHT = 0;         // 
int MAXSIZE     = 200;       //

char inputChar;              // variable to store incoming data

boolean readFrame = false;
int ligneIndex = 0;          // the row to knitt
int pixelState = 0;          // store the colore for picels
 
byte[] serialData = new byte[MAXSIZE];

boolean DEBUG = false;
boolean COMPORT = false;  // set it true to connect your knitter


void sendPixels() {

  if ( COMPORT ) {
    while (myPort.available () > 0) {
      inputChar = myPort.readChar();
      if (inputChar == HEADER && readFrame == false) {
        ligneIndex--;
        if (ligneIndex <= -1) ligneIndex = 0;
        else readFrame = true;
      }
    }
  }
  if (readFrame == true) {
    displayReaadLine();
    fill(255, 0, 0);
    text(ligneIndex, 30, height/2 - 10);

    // Read and write next frame to the serial port
    for (int i=0; i<MAXSIZE; i++) {
      if (i > MARGIN / 2 && i < myImage.width + (MARGIN/2) ) {
        pixelState = myImage.pixels[ i - (MARGIN/2) + myImage.width * ligneIndex ];

        if (pixelState == -1) serialData[ i ] = 1;
        if (pixelState == -16777216) serialData[ i ] = 0;
      } else {
        serialData[i] = 1;
      }
      if (COMPORT) myPort.write( serialData[i] );
      if (DEBUG) print( serialData[i] );
      readFrame = false;
    }
    if (COMPORT) myPort.write( FOOTER );
    if (DEBUG) println( FOOTER );
  }
}

// Draw two red lines to visualise the current frame onto the pattern
void displayReaadLine() {
  strokeWeight(1.1);
  stroke(255, 0, 0);
  line(0, height/2, width, height/2);
  line(0, height/2 + PIXELHEIGHT, width, height/2 + PIXELHEIGHT);
}