// Maurin Donneaud : maurin@datapaulette.org
// 4x4 e-textile matrix for Arduino I2C bus based
// Master is Teensy 2.0 / Pin 6 ( SDA ), Pin 5 ( SCL ) see : https://www.pjrc.com/teensy/td_libs_Wire.html
// licence GPL V2.0

#include <Wire.h>

#define  BAUD_RATE         115200
#define  ROWS              3
#define  COLS              3
#define  PAYLOAD_SIZE      ROWS*COLS*2 // bytes expected to be received by the master I2C master
#define  FOOTER            255
#define  LED_PIN           11
#define  I2C_SLAVE_START   33

int DEVICES = 0;

byte incomingByte = 0;
boolean TRANSMIT_ARDUINO = false;
boolean RUN = false;
boolean toggleLed = false;

/////////////////////////////////////////////////////////// SETUP
void setup() {
  Serial.begin( BAUD_RATE );           // start serial for output
  pinMode( LED_PIN, OUTPUT );          // Set led pin OUTPUT
  digitalWrite( LED_PIN, LOW );        // Set led OFF
  Wire.begin();                        // join i2c bus (address optional for master)
  if ( TRANSMIT_ARDUINO ) Serial.println( "START" );
  blinkBlink( 11 );
}

/////////////////////////////////////////////////////////// LOOP
void loop() {

  if ( Serial.available() > 0 ) {
    DEVICES = Serial.read();
    if ( TRANSMIT_ARDUINO ) Serial.println( DEVICES );
    RUN = true;
    // Wire.write( I2C_SLAVE_START );
    digitalWrite( LED_PIN, HIGH );
    delay( 100 );
  }

  if ( RUN ) {
    for ( byte i = 0; i < DEVICES; i++ ) {
      Wire.requestFrom( i, PAYLOAD_SIZE );    // request 18 bytes from slave device #0, #1, ...

      // slave may send less than requested
      while ( Wire.available() > 0 ) {
        incomingByte = Wire.read(); // receive a byte as character
        if ( !TRANSMIT_ARDUINO ) Serial.write( incomingByte ); // print the character
        if ( TRANSMIT_ARDUINO ) Serial.print( incomingByte ), Serial.print( " " ); // print the character
      }
      if ( !TRANSMIT_ARDUINO ) Serial.write( i ); // print the character
      if ( !TRANSMIT_ARDUINO ) Serial.write( FOOTER ); // print the character
      if ( TRANSMIT_ARDUINO ) Serial.println( i );
    }
  }
}

void blinkBlink( int times ) {
  for ( int i = 0; i < times; i++ ) {
    digitalWrite( LED_PIN, toggleLed );
    delay( 50 );
    toggleLed = !toggleLed;
  }
}

