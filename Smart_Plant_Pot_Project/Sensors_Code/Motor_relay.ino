#define CW 6 //CW is defined as pin #7//
#define CCW 5 //CCW is defined as pin #8//
#define CCWW 7 //CCWW is defined as pin #6//
#define CCCWW 8 //CCCWW is defined as pin #5//
void setup() { //Setup runs once//

  pinMode(CW, OUTPUT); //Set CW as an output//
  pinMode(CCW, OUTPUT); //Set CCW as an output//
  pinMode(CCWW, OUTPUT); //Set CCWW as an output//
  pinMode(CCCWW, OUTPUT); //Set CCCWW as an output//  
}

void loop() { //Loop runs forever//
  
   

  digitalWrite(CW,HIGH); //Motor runs clockwise//
  delay(1000);            //for 1 second// 
  digitalWrite(CW, LOW); //Motor stops//
  delay(1000);
  digitalWrite(CCW,HIGH); //Motor runs clockwise//
  delay(1000);            //for 1 second// 
  digitalWrite(CCW, LOW); //Motor stops//
      

}
