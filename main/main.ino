#include <ESP8266WiFi.h>  
#include <IRsend.h> 
#include <ir_Fujitsu.h>
IRFujitsuAC fujitsu(12);  // IR led controlled by Pin D1.

const char* ssid     = "Karthik_2.4GHz";
const char* password = "Karthik@123";  

long duration;
int distance;
const int trigPin = 4;
const int echoPin = 5;
const int IRLEDPin = 12;
const int buzzerPin=13;
const int IRRecvPin = 14;
const int httpPort = 80;


int timepassed=0;
int val=0;
String stemp;
int temp=0; 



WiFiClient client; 

 
void setup() {

pinMode(trigPin, OUTPUT);  
pinMode(LED_BUILTIN, OUTPUT); 
pinMode(buzzerPin, OUTPUT);  
pinMode(IRLEDPin, OUTPUT); 

  Serial.begin(115200);
  delay(1000); 
  
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
     digitalWrite(LED_BUILTIN, HIGH); 
  while (WiFi.status() != WL_CONNECTED) { 
            Serial.print(".");
buzz(10); 
 

delay(1000);
  } 
buzz(150);
buzz(100);
buzz(50);
  Serial.println("WiFi connected");  
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());  
 
 
 fujitsu.begin();


 }
 
 
void sendData(char* host,char* url, String body)
{
  digitalWrite(LED_BUILTIN, LOW);
  Serial.print("connecting to ");
  Serial.println(host);
  if (!client.connect(host,80)) {
    Serial.println("connection failed");
    return;
  } 
    
  Serial.print("Requesting URL: ");
  Serial.println(url);
  Serial.print("Body: ");
  Serial.println(body);
  
  client.print(String("POST ") + url + " HTTP/1.1\r\n" + "Host: " + host + "\r\n" + "Content-Type: application/json" + "\r\n" + "Content-Length: "+body.length() + "\r\n" + "Connection: Close\r\n\r\n");
  client.print(body);
  unsigned long timeout = millis();
  while (client.available() == 0) {
    if (millis() - timeout > 5000) {
      Serial.println(">>> Client Timeout !");
      client.stop();
      return;
    }
  }
   
// while(client.available()){
//  String line = client.readStringUntil('\r');
//  Serial.print(line);
//  }
  
  Serial.println();
  Serial.println("closing connection");
  
 digitalWrite(LED_BUILTIN, HIGH); 
 timepassed=millis();

}


void loop() {

  if(millis() - timepassed >50000 && temp==0) 
  {
    timepassed=millis();   
    getDistance();
    String body="{\"value\":"+String(distance)+"}";
    sendData("things.ubidots.com","/api/v1.6/devices/water-tank/distance/values?token=A1E-k6sqcpU3tDjLSUHvmnkrPzrqODzXVD",body); 
  }
 getDoorStatus(); 
 delay(50);
 


 }


int getDoorStatus(){
val = analogRead(A0);  
if(val>=850 ) {buzz(100); stemp="  wire short"; temp=-1;}
else
if(val>=650 && val <= 849) {stemp=" closed"; temp= 0;}
else
if(val>=450 && val <= 649) {buzz(200); stemp=" open"; temp=1;}
else
if(val<=449){ buzz(100); stemp=" wire cut"; temp= -2;}
 

return temp;
}
 

void buzz(int speed){ 
digitalWrite(buzzerPin, LOW);          
digitalWrite(LED_BUILTIN, HIGH);

delay(speed); 
digitalWrite(buzzerPin, HIGH);
digitalWrite(LED_BUILTIN, LOW);

delay(speed);
digitalWrite(buzzerPin, LOW);
digitalWrite(LED_BUILTIN, HIGH);

}


int getDistance()
{
digitalWrite(trigPin, LOW); // Clears the trigPin
delayMicroseconds(2); // Sets the trigPin on HIGH state for 10 micro seconds
digitalWrite(trigPin, HIGH); 
delayMicroseconds(10);
digitalWrite(trigPin, LOW);
duration = pulseIn(echoPin, HIGH);  // Reads the echoPin, returns the sound wave travel time in microseconds
distance= duration*0.034/2; // Calculating the distance
Serial.print("Distance: ");
Serial.println(distance);
return distance;
}

 
