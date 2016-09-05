int FOOTER = 255;                      // 
int BYTES = ROWS*COLS*2+1;             // 3 x 3 x 2 + 1
int serialData[ ] = new int[ BYTES ];  //
int index = 0;                         // 0 - 512
int storedValue[ ][ ][ ] = new int[ 255 ][ 4 ][ 4 ];

void serialEvent( Serial myPort ) {

  while ( myPort.available () > 0 ) {
    int inputValue = myPort.readChar();
    if ( inputValue == FOOTER ) {
      int sensorID = serialData[ BYTES - 1 ];
      if ( DEBUG_SENSOR_ID ) println( sensorID + "\t");
      if ( DEBUG_SENSOR_VALUES || DEBUG_SENSOR_POS ) println();
      for ( int i=0; i<BYTES-1; i=i+2 ) {
        int lowBit = byte( serialData[ i ] );
        int highBit = byte( serialData[ i+1 ] ) << 7;
        int value = lowBit | highBit;
        if ( DEBUG_SENSOR_VALUES ) print( value + "\t" );
        int row =  int( i / ( 2*ROWS ) );
        if ( DEBUG_SENSOR_POS ) print( row + "_");
        int col = int( i/2 ) % COLS;
        if ( DEBUG_SENSOR_POS ) print( col + " ");
        storedValue[ sensorID ][ row ][ col ] = value;
      }
      index = 0;
    } else if ( index < BYTES ) {
      serialData[ index ] = inputValue;
      index++;
    }
  }
}