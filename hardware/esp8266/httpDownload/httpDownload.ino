#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266HTTPClient.h>
#include <LittleFS.h>

// Serial Port
uint16_t len;
uint16_t baud = 9600;

// Telnet
const int  MAX_CLIENTS = 3;
WiFiServer server(51515); // Telnet server on port 51515
WiFiClient serverClients[MAX_CLIENTS];

void setup() {
  int total_delay=0;
  //ESP.wdtEnable(1000);  // 1 second watchdog timeout
  Serial.begin(baud);
  WiFi.begin("", "");
  while (WiFi.status() != WL_CONNECTED){
    delay(1000);
  }

  server.begin(); 
}

void loop() {
  int len = 0;
  bool newClientAdded = false;

  for (uint8_t i = 0; i < MAX_CLIENTS; i++) {
    if (serverClients[i] && serverClients[i].connected()) {
      while(serverClients[i].available()) {
        char c = serverClients[i].read();
        if(c != 0x0D) Serial.write(c);
        if(len % 512 == 0){
          delay(50);
          yield();
        }
        len++;
      }
    }
  }

  if (server.hasClient()) {
    for (int i = 0; i < MAX_CLIENTS; i++) {
      // Find the first available slot for a new client
      if (!serverClients[i] || !serverClients[i].connected()) {
        if (serverClients[i]) serverClients[i].stop();
        serverClients[i] = server.available();
        newClientAdded = true;
        break;  // exit the loop
      }
    }

    if (!newClientAdded) {
      // No slots available, so reject the additional client
      WiFiClient serverClient = server.available();
      serverClient.stop();
    }
  }

  while(Serial.available()){
    char c = Serial.read();
    for (int i = 0; i < MAX_CLIENTS; i++) {
      if(serverClients[i] && serverClients[i].connected()) {
        serverClients[i].write(c);
      }
    }
  }
}