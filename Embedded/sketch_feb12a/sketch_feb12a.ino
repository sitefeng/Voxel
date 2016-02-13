#include <ESP8266WiFi.h>

//////////////////////
// WiFi Definitions //
//////////////////////
const char WiFiAPPSK[] = "sparkfun";

/////////////////////
// Pin Definitions //
/////////////////////
const int LED_PIN = 0; // Thing's onboard, green LED

const int RED_PIN = 12;
const int GREEN_PIN = 13;
const int BLUE_PIN = 14;

const int BUTTON_PIN = 4;

const int ANALOG_PIN = A0; // The only analog pin on the Thing
const int DIGITAL_PIN = 12; // Digital pin to be read

int ledStatus = 0;

WiFiServer server(80);

void setup() 
{
  initHardware();
  setupWiFi();
  server.begin();
}

void loop() 
{
  // Check if a client has connected
  WiFiClient client = server.available();
  if (!client) {
    return;
  }

  // Read the first line of the request
  String req = client.readStringUntil('\r');
  Serial.println(req);
  client.flush();

  // Match the request

  if (req.indexOf("/led/0") != -1)
    ledStatus = 0; // Will write LED low
  else if (req.indexOf("/led/1") != -1)
    ledStatus = 1; // Will write LED high
  else if (req.indexOf("/read") != -1)
    ledStatus = -2; // Will print pin reads
  else {
    ledStatus = -99;
  }

  // Set GPIO5 according to the request
  if (ledStatus >= 0) {
    digitalWrite(LED_PIN, !ledStatus);
    digitalWrite(GREEN_PIN, ledStatus);
    digitalWrite(BLUE_PIN, ledStatus);
    digitalWrite(RED_PIN, ledStatus);
  }
  

  client.flush();

  // Prepare the response. Start with the common header:
  String s = "HTTP/1.1 200 OK\r\n";
  s += "Content-Type: text/html\r\n\r\n";
  s += "<!DOCTYPE HTML>\r\n<html>\r\n";
  // If we're setting the LED, print out a message saying we did
  if (ledStatus >= 0)
  {
    s += "LED is now ";
    s += (ledStatus)? "on":"off";
  }
  else if (ledStatus == -2)
  { // If we're reading pins, print out those values:
    s += "Analog Pin = ";
    s += String(analogRead(ANALOG_PIN));
    s += "<br>"; // Go to the next line.
    s += "Digital Pin 12 = ";
    s += String(digitalRead(DIGITAL_PIN));
  }
  else
  {
    s += "Invalid Request, showing custom output.<br>";
    s += "ledStatus:";
    s += String(ledStatus);
    s += "<br>";
  }
  s += "</html>\n";

  // Send the response to the client
  client.print(s);
  delay(10);
  Serial.println("Client disonnected");

  // The client will actually be disconnected 
  // when the function returns and 'client' object is detroyed

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

void buttonPressed() {
  ledStatus = !ledStatus;
  digitalWrite(LED_PIN, !ledStatus);
  analogWrite(RED_PIN, 100*!ledStatus);
  analogWrite(GREEN_PIN, 100*!ledStatus);
  analogWrite(BLUE_PIN, 100*!ledStatus);
  delay(10);
}

