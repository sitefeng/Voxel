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
float brightness = 1; // 0 to 1
int numModules = 5;

///////////////////////////////
// Private Global Variables  //
///////////////////////////////
volatile bool shouldStart = false;

unsigned char *bitmap = NULL;
int imageWidth = 0;
int imageHeight = 0;

#define base64ImageSize 512;
char base64Image[base64ImageSize];


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




static char encoding_table[] = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
    'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
    'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
    'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3',
    '4', '5', '6', '7', '8', '9', '+', '/'};
static char *decoding_table = NULL;
static int mod_table[] = {0, 2, 1};

    
unsigned char *base64_decode(const char *data,
                             size_t input_length,
                             size_t *output_length) {
    
    if (decoding_table == NULL) build_decoding_table();
    
    if (input_length % 4 != 0) return NULL;
    
    *output_length = input_length / 4 * 3;
    if (data[input_length - 1] == '=') (*output_length)--;
    if (data[input_length - 2] == '=') (*output_length)--;
    
    unsigned char *decoded_data = malloc(*output_length);
    if (decoded_data == NULL) return NULL;
    
    for (int i = 0, j = 0; i < input_length;) {
        
        uint32_t sextet_a = data[i] == '=' ? 0 & i++ : decoding_table[data[i++]];
        uint32_t sextet_b = data[i] == '=' ? 0 & i++ : decoding_table[data[i++]];
        uint32_t sextet_c = data[i] == '=' ? 0 & i++ : decoding_table[data[i++]];
        uint32_t sextet_d = data[i] == '=' ? 0 & i++ : decoding_table[data[i++]];
        
        uint32_t triple = (sextet_a << 3 * 6)
        + (sextet_b << 2 * 6)
        + (sextet_c << 1 * 6)
        + (sextet_d << 0 * 6);
        
        if (j < *output_length) decoded_data[j++] = (triple >> 2 * 8) & 0xFF;
        if (j < *output_length) decoded_data[j++] = (triple >> 1 * 8) & 0xFF;
        if (j < *output_length) decoded_data[j++] = (triple >> 0 * 8) & 0xFF;
    }
    
    return decoded_data;
}
    
    
void build_decoding_table() {
    
    decoding_table = malloc(256);
    
    for (int i = 0; i < 64; i++)
        decoding_table[(unsigned char) encoding_table[i]] = i;
}


void base64_cleanup() {
    free(decoding_table);
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
  Serial.println(commandStr);

  int endPos = commandStr.indexOf(" ");
  commandStr.remove(endPos);
  Serial.println(commandStr);

  String commandId = commandStr.substring(0, 1);
  commandStr.remove(0, 1);

  size_t decodedLength = 0;
  commandStr.toCharArray(base64Image, base64ImageLength);
  bitmap = base64_decode(&base64Image, commandStr.length(), &decodedLength);
    
  // Prepare the response. Start with the common header:
  String s = "HTTP/1.1 200 OK\r\n";
  s += "Content-Type: text/html\r\n\r\n";
  s += "<!DOCTYPE HTML>\r\n<html>\r\n";
  
  s += "<h1>Hello World</h1>\r\n";
  s += "Command:";
  s += commandStr;
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

  while (shouldStart) {
    shouldStart = false;
    displayImage();
  }
  
}


void displayImage() {
  for (int i=0; i< imageWidth; i++) {
      uint8_t r = bitmap[i];
      uint8_t g = bitmap[i+1];
      uint8_t b = bitmap[i+2];

      for (int j=0; j< imageHeight; j++) {
        
      }
      
      delay(1/freq * 1000);
  }
}


// Interrupt Callback Functions
void buttonPressed() {
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

