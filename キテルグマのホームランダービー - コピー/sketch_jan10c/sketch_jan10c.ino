const int ACCX = A0;
const int ACCY = A1;
const int ACCZ = A2;
int MOTOR = 9;
int val;
 byte sensors[3];
void setup() {
  // put your setup code here, to run once:
  pinMode(MOTOR,OUTPUT);
Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
int x = analogRead(ACCX);
int y = analogRead(ACCY);
int z = analogRead(ACCZ);
sensors[0]=x;
sensors[1]=y;
sensors[2]=z;
Serial.write(x);
Serial.write(y);
Serial.write(z);

if(Serial.available()>0){
  val=Serial.read();
  if(val==1){
    analogWrite(MOTOR,255);
  }else{
    analogWrite(MOTOR,0);
  }
}
delay(10);



     
}
