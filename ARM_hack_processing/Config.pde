/*
This sketch read pixels from an array to control a LED ribbon of WS2812
 Copyright (C) 2016 Maurin Donneaud - maurin@datapaulette.org
 It use Processing 3.0
 */

XML xml;

/////////////////// Read values from XML config file  
void codeSetup() {

  xml = loadXML( "config.xml" );
  XML[] children = xml.getChildren( "code" );

  for (int i=0; i<children.length; i++) {
    switch( i ) {
    case 0: 
      X_MATRIX = children[ i ].getInt( "X_MATRIX" );
      if ( DEBUG_CONFIG ) println( "X_MATRIX : " + X_MATRIX );
      break;
    case 1: 
      Y_MATRIX = children[ i ].getInt( "Y_MATRIX" );
      if ( DEBUG_CONFIG ) println( "Y_MATRIX : " + Y_MATRIX );
      break;
    case 2:
      PIX_SIZE = children[ i ].getInt( "PIX_SIZE" );
      if ( DEBUG_CONFIG ) println( "PIX_SIZE : " + PIX_SIZE );
      break;
    case 3: 
      PADDING = children[ i ].getInt( "PADDING" );
      if ( DEBUG_CONFIG ) println( "PADDING : " + PADDING );
      break;
    case 4: 
      MARGIN = children[ i ].getInt( "MARGIN" );
      if ( DEBUG_CONFIG ) println( "MARGIN : " + MARGIN );
      break;
    case 5: 
      OFFSET = children[ i ].getInt( "OFFSET" );
      if ( DEBUG_CONFIG ) println( "OFFSET : " + OFFSET );
      break;
    case 6: 
      THRESHOLD = children[ i ].getInt( "THRESHOLD" );
      if ( DEBUG_CONFIG ) println( "THRESHOLD : " + THRESHOLD );
      break;
    case 7: 
      FILE = children[ i ].getString( "FILE" );
      if ( DEBUG_CONFIG ) println( "FILE : " + FILE );
      break;
    }
  }
}