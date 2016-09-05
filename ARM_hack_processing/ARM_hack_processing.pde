/*
This sketch read pixels from an array to control a LED ribbon of WS2812
 Copyright (C) 2016 Maurin Donneaud - maurin@datapaulette.org
 It use Processing 3.0
 */

import processing.serial.*;
import controlP5.*;
import themidibus.*;

Serial               myPort;        // Create object from menu class
ControlP5            cp5;           // Create object from menu class
ScrollableList       p1;            // Create object from menu class
ScrollableList       p2;            // Create object from menu class
MidiBus              outgoing;      // Create object from menu class

int X_SCREN_SIZE =   0;
int Y_SCREN_SIZE =   0;

int X_MATRIX =       0;
int Y_MATRIX =       0;
int PIX_SIZE =       0;
int PADDING =        0;  // space between each button
int MARGIN =         0;  // space between each matrix
int OFFSET =         0;
int THRESHOLD =      0;

int ROWS =           3;  // DO NOT CHANGE
int COLS =           3;  // DO NOT CHANGE
int DEVICES =        0;
int posX =           0;  // X matrix position
int posY =           0;  // Y matrix position
int menuXsize =      256;
long curentMillis =  0;
long lastMillis =    0;
long lastDebounceMillis = 0;

boolean toggleStop = true;
int STOP_TIME = 10000;
int DEBOUNCE_TIME = 30; // Ajuster le temps (pas trop petit et pas trop grand : 500 - 2000)

PFont font;
Table table;
String FILE = "saved.csv";

Selector selector = new Selector( );

int[][] colors = {
  { 250, 250, 250 }, 
  { 0, 150, 150 }, 
  { 100, 10, 15 }, 
  { 0, 220, 50 }, 
  { 255, 250, 0 }, 
  { 255, 0, 200 }, 
  { 80, 10, 130 }, 
  { 44, 200, 120 }, 
  { 80, 20, 200 }, 
  { 33, 130, 20 }, 
  { 77, 179, 150 }, 
  { 12, 10, 50 }, 
  { 15, 30, 110 }, 
  { 225, 60, 50 }, 
  { 180, 30, 180 }, 
  { 203, 22, 10 }
};

sensorMatrix sMatrix[];

char MODE = 'H';
boolean DISPLAY_MATRIX = false;
boolean DEBUG_SENSOR_VALUES = false; // cool
boolean DEBUG_SENSOR_ID = false;
boolean DEBUG_SENSOR_POS = false;
boolean DEBUG_SWITCH = false;
boolean DEBUG_CONFIG = false;

/////////////////////////////////////////////// SETUP
void setup() {

  // Set the corect port name
  String PORTNAME = Serial.list()[PORTNUMBER];
  // println(PORTNAME);
  if (COMPORT) myPort = new Serial(this, PORTNAME, BAUDERATE);

  surface.setTitle( "ARM_hack - V0.1 - Design dy DATAPAULETTE" );
  codeSetup(); // Read values from XML config file

  X_SCREN_SIZE = X_MATRIX*COLS*PIX_SIZE + X_MATRIX*( COLS-1 )*PADDING + ( X_MATRIX-1 )*MARGIN + OFFSET;
  Y_SCREN_SIZE = Y_MATRIX*ROWS*PIX_SIZE + Y_MATRIX*( ROWS-1 )*PADDING + ( Y_MATRIX-1 )*MARGIN + OFFSET;
  surface.setSize( X_SCREN_SIZE, Y_SCREN_SIZE );
  // fullScreen( );

  selector.setPos( 20, OFFSET/4 ); //posX, posY

  // Setup the save file
  table = new Table();
  table.addColumn( "id" );
  table.addColumn( "idX" );
  table.addColumn( "idY" );
  table.addColumn( "Value" );

  DEVICES = X_MATRIX * Y_MATRIX;

  font = createFont( "arial", PIX_SIZE/2 );
  frameRate( 20 );
  textFont( font );

  cp5 = new ControlP5( this );
  p1 = cp5.addScrollableList( "usbPort" );
  setupMenu( p1 );

  sMatrix = new sensorMatrix[ DEVICES ]; // Tableau de matrices de capteurs

  for ( int id=0; id<DEVICES; id++ ) {
    sMatrix[ id ] = new sensorMatrix( id );
  }
  outgoing.list();
}

/////////////////// LOOP
void draw() {

  curentMillis = millis();

  if ( MODE == 'R' ) background( 150, 10, 100 );
  if ( MODE == 'P' ) background( 10, 189, 60 );

  for ( int id=0; id<DEVICES; id++ ) {
    // sMatrix[ id ].update();
    sMatrix[ id ].display();
  }
  selector.display();

  if ( MODE == 'H' ) howTo();
}

void mousePressed() {

  int mX = mouseX;
  int mY = mouseY;

  if ( DISPLAY_MATRIX ) {
    for ( int id=0; id<DEVICES; id++ ) {
      sMatrix[ id ].onClic( mX, mY );
    }
    selector.onClic( mX, mY );
  }
}

void keyPressed() {

  if ( key == 'H' ) { // Display the help menu
    MODE = 'H';
    DISPLAY_MATRIX = false;
    p1.show();
    p2.show();
    println( "HELP MODE" );
  }
  if ( key == 'R' ) { // Record mode for the mapping
    MODE = 'R';
    DISPLAY_MATRIX = true;
    p1.hide();
    p2.hide();
    selector.show();
    rec();
  }
  if ( key == 'P' ) { // Set play mode
    MODE = 'P';
    DISPLAY_MATRIX = true;
    p1.hide();
    p2.hide();
    selector.hide();
    play();
  }
  if ( key == 'L' ) { // Lode saved file
    load( FILE );
  }
  if ( key == 'S' ) { // Save the mapping
    save( FILE );
  }
  if (key == 'd') {
    DEBUG = !DEBUG;
  }

  if (key == CODED) {
    if (keyCode == DOWN) {
      if (ligneIndex <= 0) {
        ligneIndex = 0;
      } else {
        ligneIndex--;
        readFrame = true;
      }
    }
    if (keyCode == UP) {
      if (ligneIndex >= X_MATRIX - 1) ligneIndex = X_MATRIX - 1;
      else {
        ligneIndex++;
        readFrame = true;
      }
    }
    if (keyCode == RIGHT) {
      ligneIndex = X_MATRIX - 1;
      readFrame = true;
    }
    if (keyCode == LEFT) {
      ligneIndex = 0;
      readFrame = true;
    }
  }
}