const int buttonPin = 8;     
const int ledPin =  7;      

int buttonState = 0;         

void setup() {
  pinMode(ledPin, OUTPUT); //light
  pinMode(buttonPin, INPUT); //tilt sensor
}

void loop() {
  buttonState = digitalRead(buttonPin);

  if (buttonState == HIGH) { //if tilted (door know turned)
    digitalWrite(ledPin, HIGH); //turn light on
  } else {
    digitalWrite(ledPin, LOW); //else turn light off
  }
}
