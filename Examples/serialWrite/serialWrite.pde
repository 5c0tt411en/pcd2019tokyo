import processing.serial.*;

Serial s;
String portName = "/dev/tty.wchusbserial1410";

void setup() {
    s = new Serial(this, portName, 115200);
}

void draw() {
    if (s.available() > 0)
        println(s.readString());
}

void keyReleased() {
    s.write("?\n");
}
