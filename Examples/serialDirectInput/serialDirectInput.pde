import processing.serial.*;
import controlP5.*;

Serial s;
ControlP5 gui;

String portName = "/dev/tty.wchusbserial1410";

void setup() {
    size(800, 600);
    s = new Serial(this, portName, 115200);

    gui = new ControlP5(this);
    gui.addTextfield("manualInput")
        .setPosition(20, 60);
    gui.addButton("sendMessage")
        .setPosition(80, 90);
}

void draw() {
    background(0);
    if (s.available() > 0)
        println(s.readString());
}

void sendMessage() {
    s.write(gui.get(Textfield.class, "manualInput").getText() + "\n");
}
