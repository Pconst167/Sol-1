/*
  dal0..dal7: 0 .. 7 
  mr: 8
  cs: 9
  a0: 10 
  a1: 11
  rw: 12
  drq: 13
  intrq: ana0
  dden:  ana1
*/

// Pin definitions
#define DAL0 0
#define DAL1 1
#define DAL2 2
#define DAL3 3
#define DAL4 4
#define DAL5 5
#define DAL6 6
#define DAL7 7

#define MR 8
#define CS 9
#define A0 10
#define A1 11
#define RW 12
#define DRQ 13

#define INTRQ A0
#define DDEN A1



void setDataAsOutput(){
  for (int i = DAL0; i <= DAL7; i++) {
    pinMode(i, OUTPUT);
  }
}
void setDataAsInput(){
  for (int i = DAL0; i <= DAL7; i++) {
    pinMode(i, INPUT);
  }
}



void seekTrack0() {
  digitalWrite(A0, LOW);  // 
  digitalWrite(A1, LOW);  // Select command register
  digitalWrite(RW, LOW);  // Set for write operation
  // Load Restore command (0x0F) into data bus
  setDataBus(0xB);  // 0000_1011  step rate = 30ms, enable motor on headstart

  // Pulse the chip select line to latch the command
  digitalWrite(CS, LOW);
  delayMicroseconds(1);
  digitalWrite(CS, HIGH);

  // Wait for INTRQ to go HIGH, indicating command completion
  Serial.println("Waiting for IRQ...");
  while (digitalRead(INTRQ) != HIGH);

  setDataAsInput(); // set dat  a lines as inputs
  // Check if we are on track 0 by reading the track register
  digitalWrite(A0, HIGH);  // Select status register
  digitalWrite(A1, LOW); // Select status register
  digitalWrite(RW, HIGH); // Set for read operation
  digitalWrite(CS, LOW); // Enable chip select
  delayMicroseconds(1);
  byte trackReg = readDataBus();
  digitalWrite(CS, HIGH);  // Disable chip select

  Serial.print("Value of Track register: ");
  Serial.println(trackReg);
  
  
}

void setDataBus(byte data) {
  for (int i = 0; i < 8; i++) {
    digitalWrite(DAL0 + i, (data >> i) & 0x01);
  }
}

byte readDataBus() {
  byte data = 0;
  for (int i = 0; i < 8; i++) {
    if (digitalRead(DAL0 + i)) {
      data |= (1 << i);
    }
  }
  return data;
}

void setup() {
  Serial.begin(9600);
  while (!Serial) {
    ; // Wait for serial port to connect. Needed for native USB
  }
  // Set data lines as outputs
  setDataAsOutput();

  // Set control lines as outputs
  Serial.println("Setting Control Lines...");
  pinMode(MR,   OUTPUT);
  pinMode(CS,   OUTPUT);
  pinMode(A0,   OUTPUT);
  pinMode(A1,   OUTPUT);
  pinMode(RW,   OUTPUT);
  pinMode(DDEN, OUTPUT);
  pinMode(DRQ,   INPUT);
  pinMode(INTRQ, INPUT);

  // set values for the output pins
  digitalWrite(MR,   HIGH);
  digitalWrite(CS,   HIGH);
  digitalWrite(A0,   LOW);
  digitalWrite(A1,   LOW);
  digitalWrite(RW,   HIGH); // select read mode
  digitalWrite(DDEN, HIGH); // select high density mode

  // reset the WD1770  
  Serial.println("Resetting WD1770...");
  digitalWrite(MR, LOW);  // Assert Master Reset
  delay(10);              // Hold reset for 10ms
  digitalWrite(MR, HIGH); // Release Master Reset
  delay(10);              // Allow time for WD1770 to initialize
  
  // Seek to track 0
  Serial.println("Seeking to Track00...");
  seekTrack0();

  Serial.println("Finished.");
}

void loop() {
  // Main loop does nothing, as the task is completed in setup
}
