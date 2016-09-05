/*
This sketch read pixels from an array to control a LED ribbon of WS2812
 Copyright (C) 2016 Maurin Donneaud - maurin@datapaulette.org
 It use Processing 3.0
 */

////////// Setup the menu
void setupMenu( ScrollableList ddl ) {
  String available_output[];
  int itemHeight = 30;
  int itemWidth = 250;

  ddl.setBarHeight( itemHeight );
  ddl.setItemHeight( itemHeight );

  if ( ddl == p1 ) {
    ddl.setPosition( 0, 0); ////////////////////////////////////////////// ERROR
    ddl.setCaptionLabel( "USB PORT" );
    for ( int i=0; i<Serial.list ().length; i++ ) {
      String portName = Serial.list()[ i ];
      p1.addItem( portName, i );
    }  
    ddl.setSize( itemWidth, Serial.list().length/2 * itemHeight );  //
  }
  ddl.setBackgroundColor( color(10, 15, 0) );
  ddl.setColorBackground( color(100, 105, 100) );
  ddl.close();
}

////////// Get the port number 
void controlEvent( ControlEvent theEvent ) {
  int BAUD_RATE = 115200;
  int portValue = 0;
  String USB_PORT = "none";

  if ( theEvent.isController() ) {

    //////////////////////////////////////////////////////////// USB PORT
    if ( theEvent.controller().getName() == "usbPort" ) {
      portValue = ( int ) theEvent.controller().getValue();
      USB_PORT = Serial.list()[ portValue ];

      try {
        myPort = new Serial( this, USB_PORT, BAUD_RATE );
        println( "USB_DEVICES : " + USB_PORT );
        myPort.write( DEVICES );
        p1.setColorBackground( color( 10, 255, 0 ) );
        load( FILE ); // BUGGED
      }
      catch ( Exception e ) {
        fill( 255, 0, 0 );
        textAlign( CENTER );
        textSize( X_SCREN_SIZE/8 );
        text("WRONG USB", X_SCREN_SIZE/2, Y_SCREN_SIZE/2 );
        println( "WRONG USB PORT : " + USB_PORT );
        p1.setColorBackground( color( 255, 105, 100 ) );
      }
    }
  }
}