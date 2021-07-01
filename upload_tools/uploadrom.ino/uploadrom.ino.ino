#define EEPROM_D0 2
#define EEPROM_D7 9
#define OUTPUT_EN 10
#define WRITE_EN 11

#define READ_SIZE 256

int ADDR[] = {A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14};
long ROM_SIZE = 32768L;

/*
 * Output the address bits and outputEnable signal using shift registers.
 */
void setAddress(unsigned long address, bool outputEnable) {
  for (int i = 0; i <= 14; i++) {
    digitalWrite(ADDR[i], address & 1);
    address >>= 1;
  }
  delay(100);
  digitalWrite(OUTPUT_EN, outputEnable ? LOW : HIGH);
}


/*
 * Read a byte from the EEPROM at the specified address.
 */
byte readEEPROM(unsigned long address) {
  setAddress(address, /*outputEnable*/ true);
  delay(50);
  for (int pin = EEPROM_D0; pin <= EEPROM_D7; pin += 1) {
    pinMode(pin, INPUT);
  }
  setAddress(address, /*outputEnable*/ true);

  byte data = 0;
  for (int pin = EEPROM_D7; pin >= EEPROM_D0; pin -= 1) {
    data = (data << 1) + digitalRead(pin);
  }
  return data;
}


/*
 * Write a byte to the EEPROM at the specified address.
 */
void writeEEPROM(unsigned long address, byte data) {
  setAddress(address, /*outputEnable*/ false);
  for (int pin = EEPROM_D0; pin <= EEPROM_D7; pin += 1) {
    pinMode(pin, OUTPUT);
  }
  delayMicroseconds(5);

  for (int pin = EEPROM_D0; pin <= EEPROM_D7; pin += 1) {
    digitalWrite(pin, data & 1);
    data = data >> 1;
  }
  delay(100);
  digitalWrite(WRITE_EN, LOW);
  delayMicroseconds(1);
  digitalWrite(WRITE_EN, HIGH);
}


/*
 * Read the contents of the EEPROM and print them to the serial monitor.
 */
void printContents() {
  delay(500);
  for (long base = 0; base < ROM_SIZE; base += 16) {
    byte data[16];
    for (int offset = 0; offset <= 15; offset += 1) {
      data[offset] = readEEPROM(base + offset);
    }

    char buf[100];
    sprintf(buf, "%04lx/%lx:  %02x %02x %02x %02x %02x %02x %02x %02x   %02x %02x %02x %02x %02x %02x %02x %02x",
            base, ROM_SIZE, data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7],
            data[8], data[9], data[10], data[11], data[12], data[13], data[14], data[15]);

    Serial.println(buf);
  }
}

void readDataFromSerial() {
  byte buffer[READ_SIZE];
  char txt_buffer[32];
  Serial.println("READY");
  long data_size = Serial.parseInt();
  sprintf(txt_buffer, "Size is %ld", data_size);
  Serial.println(txt_buffer);
  size_t size = 0;
  for (long address = 0; address < data_size; address += size) {
    size = Serial.readBytes(buffer, min(READ_SIZE, data_size - address));
    bool is_valid = false;
    while (!is_valid) {
      is_valid = true;
      for (size_t i = 0; i < size; i++) {
        writeEEPROM(address + i, buffer[i]);
        Serial.println("Write at " + String(address + i) + ": " + String(buffer[i]));
      }
      Serial.println("write");
      /*delay(1000);
      for (size_t i = 0; i < size; i++) {
        delay(100);
        byte value = readEEPROM(address + i);
        if (value != buffer[i]) {
          Serial.println("INVALID: " + String(address + i) + ": Was " + String(value) + ". Should be " + String(buffer[i]));
          writeEEPROM(address + i, buffer[i]);
          is_valid = false;
        }
        else {
          Serial.println(String(address + i) + ": WAS RIGHT - value: " + String(value));
        }
      }*/
    }
    Serial.println("DONE");
    //Serial.write(buffer, size);
  }
}

void setup() {
  digitalWrite(WRITE_EN, HIGH);
  digitalWrite(OUTPUT_EN, HIGH);
  pinMode(WRITE_EN, OUTPUT);
  for (int i = 0; i <= 14; i++) {
    pinMode(ADDR[i], OUTPUT);
  }
  Serial.begin(57600);
  while (!Serial) {
    ;
  }

  delay(100);
  Serial.println("setup done");
/*  for (long i = 0; i < ROM_SIZE; i++) {
    writeEEPROM(i, (i / 64) % 256);
    if (i % 1024 == 0) {
      Serial.println(i);
    }
  }
  return;
*/
/*
//  for (long i = 0; i < ROM_SIZE; i++) {
//    writeEEPROM(i, 0xFF);
//    if (i % 1024 == 0) {
//      Serial.println(i);
//    }
//  }
//  printContents();
//  return;
*/  
}

void loop()
{
  
  if(Serial.available() > 0) {
    byte packet[8];
    Serial.readBytes(packet, 8);

    byte op = packet[0];
    unsigned long packet_1 = packet[1];
    unsigned long packet_2 = packet[2];
    unsigned long packet_3 = packet[3];
    unsigned long address = (packet_1 << 24) + (packet_2 << 16)+ (packet_3 << 8) + packet[4];
    byte data = packet[5];
    byte u1 = packet[6];
    byte u2 = packet[7];
    byte returned_data;

    char poubelle[200];
    
    switch (op) {
    case '0':
      returned_data = readEEPROM(address);
      Serial.println(String(address) + ": " + String(returned_data));
      Serial.println("END");
      break;

    case '1':
      writeEEPROM(address, data);
      delayMicroseconds(10);
      Serial.println(String(address) + ": " + String(data) + " (Write)");
      Serial.println("END");
      break;
    case '2':
      printContents();
      Serial.println("END");
      break;
    case '3':
      readDataFromSerial();
      Serial.println("END");
      break;
    default:
      break;
      // Serial.println("INVALID OPCODE");
    }
  }
}

/*

void setup() {
  // put your setup code here, to run once:
  pinMode(WRITE_EN, OUTPUT);
  pinMode(OUTPUT_EN, OUTPUT);
  digitalWrite(WRITE_EN, HIGH);
  digitalWrite(OUTPUT_EN, HIGH);
  for (int i = 0; i <= 14; i++) {
    pinMode(ADDR[i], OUTPUT);
  }

  Serial.begin(57600);


  // Program data bytes
  delay(500);
  Serial.print("Programming EEPROM");
  for (int address = 0; address < sizeof(rom); address += 1) {
    writeEEPROM(address, rom[address]);
    Serial.println(rom[address]);

    if (address % 64 == 0) {
      Serial.print(".");
    }
  }
  //writeEEPROM(sizeof(rom), last_rom_byte);
  Serial.println(" done");


  // Read and print out the contents of the EERPROM
  Serial.println("Reading EEPROM");
  printContents();
}


void loop() {
  // put your main code here, to run repeatedly:

}*/
