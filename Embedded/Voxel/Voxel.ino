#include <ESP8266WiFi.h>
#include "FS.h"


//////////////////////
// Definitions //
//////////////////////
const char WiFiAPPSK[] = "sparkfun";
const int ledsPerModule = 57;

/////////////////////
// Pin Definitions //
/////////////////////
const int LED_PIN = 0; // onboard LED

const int RED_PIN = 12;
const int GREEN_PIN = 13;
const int BLUE_PIN = 14;

const int BUTTON_PIN = 4;

const int ANALOG_PIN = A0; // The only analog pin on the Thing
const int DIGITAL_PIN = 12; // Digital pin to be read

///////////////////////////////
// User Settings             //
///////////////////////////////
int ledFrequency = 4; //Hz
float brightness = 1; // 0 to 1 TODO
int numRepeats = 1; // TODO
int numModules = 5; // TODO

///////////////////////////////
// Private Global Variables  //
///////////////////////////////
volatile bool shouldStart = true;

unsigned char *bitmap = NULL;
int imageWidth = 0;
int imageHeight = 0;

#define base64ImageLength 512
char base64Image[base64ImageLength];


//192.168.4.1/
WiFiServer server(80);

void setup() 
{
  initHardware();
  setupWiFi();
  server.begin();
}


void initHardware() {
  Serial.begin(115200);

  pinMode(LED_PIN, OUTPUT);
  pinMode(RED_PIN, OUTPUT);
  pinMode(GREEN_PIN, OUTPUT);
  pinMode(BLUE_PIN, OUTPUT);
  
  digitalWrite(LED_PIN, LOW);
  digitalWrite(RED_PIN, HIGH);
  digitalWrite(GREEN_PIN, HIGH);
  digitalWrite(BLUE_PIN, HIGH);

  pinMode(BUTTON_PIN, INPUT);
  
  attachInterrupt(digitalPinToInterrupt(BUTTON_PIN), buttonPressed, FALLING);
}


void setupWiFi()
{
  WiFi.mode(WIFI_AP);

  // Do a little work to get a unique-ish name. Append the
  // last two bytes of the MAC (HEX'd) to "Thing-":
  uint8_t mac[WL_MAC_ADDR_LENGTH];
  WiFi.softAPmacAddress(mac);
  String macID = String(mac[WL_MAC_ADDR_LENGTH - 2], HEX) +
                 String(mac[WL_MAC_ADDR_LENGTH - 1], HEX);
  macID.toUpperCase();
  String AP_NameString = "Fusion Voxel " + macID;

  char AP_NameChar[AP_NameString.length() + 1];
  memset(AP_NameChar, 0, AP_NameString.length() + 1);

  for (int i=0; i<AP_NameString.length(); i++)
    AP_NameChar[i] = AP_NameString.charAt(i);

  WiFi.softAP(AP_NameChar, WiFiAPPSK);
}


String base64_chars = 
             "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
             "abcdefghijklmnopqrstuvwxyz"
             "0123456789+/";


bool is_base64(char c) {
  return (isalnum(c) || (c == '+') || (c == '/'));
}


unsigned char* base64_decode(String encoded_string, size_t imageSize) {
  int in_len = encoded_string.length();
  int i = 0;
  int j = 0;
  int in_ = 0;
  char char_array_4[4], char_array_3[3];
  unsigned char *ret = (unsigned char*)malloc(imageSize*3);

  int currPos = 0;
  while (in_len-- && ( encoded_string[in_] != '=') && is_base64(encoded_string[in_])) {
    char_array_4[i++] = encoded_string[in_]; in_++;
    if (i ==4) {
      for (i = 0; i <4; i++)
        char_array_4[i] = base64_chars.indexOf(char_array_4[i]);

      char_array_3[0] = (char_array_4[0] << 2) + ((char_array_4[1] & 0x30) >> 4);
      char_array_3[1] = ((char_array_4[1] & 0xf) << 4) + ((char_array_4[2] & 0x3c) >> 2);
      char_array_3[2] = ((char_array_4[2] & 0x3) << 6) + char_array_4[3];

      for (i = 0; (i < 3); i++) {
          ret[currPos] = char_array_3[i];
          currPos++;
      }
      i = 0;
    }
  }

  if (i) {
    for (j = i; j <4; j++)
      char_array_4[j] = 0;

    for (j = 0; j <4; j++)
      char_array_4[j] = base64_chars.indexOf(char_array_4[j]);

    char_array_3[0] = (char_array_4[0] << 2) + ((char_array_4[1] & 0x30) >> 4);
    char_array_3[1] = ((char_array_4[1] & 0xf) << 4) + ((char_array_4[2] & 0x3c) >> 2);
    char_array_3[2] = ((char_array_4[2] & 0x3) << 6) + char_array_4[3];

    for (j = 0; (j < i - 1); j++) {
      ret[currPos] = char_array_3[j];
      currPos++;
    }
  }

  return ret;
}



// ***********************************************
// Repeating Loop Function
void loop() 
{
  // Check if a client has connected
  WiFiClient client = server.available();
  if (!client) {
    return;
  }

  //Clean up from previous loop
  if (bitmap != NULL) {
    free(bitmap);
  }
  
  // Read the first line of the request
  //Request String
  String commandStr = client.readStringUntil('\r');
  client.flush();

  int startPos = commandStr.indexOf("/") + 1;
  commandStr.remove(0, startPos);

  int endPos = commandStr.indexOf(" ");
  commandStr.remove(endPos);

  String commandId = commandStr.substring(0, 1);
  imageWidth = commandStr.substring(1, 5).toInt();
  imageHeight = commandStr.substring(5, 9).toInt();
  commandStr.remove(0, 9);
  Serial.print(imageWidth);
  Serial.print(", ");
  Serial.println(imageHeight);
  Serial.print("imageBase64: ");
  Serial.println(commandStr);
  
  size_t decodedLength = 0;
  commandStr.toCharArray(base64Image, base64ImageLength);
//  bitmap = base64_decode(base64Image, commandStr.length(), &decodedLength);
  bitmap = base64_decode(base64Image, imageWidth*imageHeight);
  
  // Prepare the response. Start with the common header:
  String s = "HTTP/1.1 200 OK\r\n";
  s += "Content-Type: text/html\r\n\r\n";
  s += "<!DOCTYPE HTML>\r\n<html>\r\n";
  
  s += "<h1>Fusion Voxel</h1>\r\n";
  s += "CommandId:";
  s += commandId;
  s += "<hr/>";
  
  s += "<br/>\n";
  s += "ImageWidth:";
  s += String(imageWidth);
  s += "<br/>\n";
  s += "ImageHeight:";
  s += String(imageHeight);
  s += "<br/>\n";
  
  s += "</html>\n";

  // Send the response to the client
  client.print(s);
  delay(10);
  Serial.println("Client disonnected");

  // Render the Actual Image
  if (commandId.equals("1")) {
    error("Not Implemented!");
    
  } else if (commandId.equals("2")) {
    error("Not Implemented!");
    
  } else if (commandId.equals("3")) {
    for(int i=0; i<imageWidth*imageHeight*3; i++) {
      const char currByte = bitmap[i];
      Serial.print(currByte);
    }
    Serial.println("\n**********");
    
    while(true) {
      while (!shouldStart) {
        WiFiClient client = server.available();
        if (client) {
          Serial.println("While loop RETURNED");
          return;
        }
        delay(50);
      }

      for (int r=0; r<numRepeats; r++) {
        displayImage();
      }
      shouldStart = false;
    }
    
  } else {
    error("Command not supported");
  }
  
}


void displayImage() {
  for (int i=0; i< imageWidth; i++) {
      for (int j=0; j< imageHeight; j++) {
        uint8_t r = bitmap[i*3 + 0 + j*imageWidth*3];
        uint8_t g = bitmap[i*3 + 1 + j*imageWidth*3];
        uint8_t b = bitmap[i*3 + 2 + j*imageWidth*3];

        pushLEDColor(r, g, b);
        Serial.print(r);
        Serial.print(",");
        Serial.print(g);
        Serial.print(",");
        Serial.print(b);
        Serial.print("|");
      }

      Serial.println("XXX");

      delay(1000 / ledFrequency);
  }
}


// Interrupt Callback Functions
void buttonPressed() {
  Serial.println("ButtonPressed");
  shouldStart = true;
  delay(10);
}

// Convenience Functions

void changeFirstLEDColor(uint8_t r, uint8_t g, uint8_t b) {
  analogWrite(RED_PIN, 255 - r);
  analogWrite(GREEN_PIN, 255 - g);
  analogWrite(BLUE_PIN, 255 - b);
}

void pushLEDColor(uint8_t r, uint8_t g, uint8_t b) {
  analogWrite(RED_PIN, 255 - r);
  analogWrite(GREEN_PIN, 255 - g);
  analogWrite(BLUE_PIN, 255 - b);
}


void clearLEDModules() {
  for (int i=0; i< ledsPerModule * numModules; i++) {
      uint8_t r = 0;
      uint8_t g = 0;
      uint8_t b = 0;

      pushLEDColor(r,g,b);
  }
}


// Debug Functions
void error(String err) {
  Serial.print("ERROR: ");
  Serial.println(err);
  for (int i=0; i< 10; i++) {
    digitalWrite(LED_PIN, HIGH);
    delay(250);
    digitalWrite(LED_PIN, LOW);
    delay(250);
  }
}


