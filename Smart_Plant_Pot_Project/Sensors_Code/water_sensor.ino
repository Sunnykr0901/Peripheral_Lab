#define WATER_SENSOR 3
void setup() {
  Serial.begin(9600);
  // put your setup code here, to run once:
  pinMode(WATER_SENSOR, INPUT);
}

void loop() {
 
  // put your main code here, to run repeatedly:
  Serial.print("Water:");
    Serial.println(digitalRead(WATER_SENSOR));
}
