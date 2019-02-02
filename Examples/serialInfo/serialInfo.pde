import processing.serial.*;
import controlP5.*;

Serial s;
ControlP5 gui;
Textarea infoArea;

String portName = "/dev/tty.wchusbserial1410";
String info = "";

void setup() {
    size(800, 600);
    s = new Serial(this, portName, 115200);

    gui = new ControlP5(this);
    gui.addTextfield("manualInput")
        .setPosition(20, 60);
    gui.addButton("sendMessage")
        .setPosition(80, 90);
    infoArea = gui.addTextarea("statusInfo")
        .setPosition(250, 20)
        .setSize(200, 500)
        .setLineHeight(14)
        .setColor(color(128))
        .setColorBackground(color(255, 100))
        ;
    infoArea.setText(info);
}

void draw() {
    background(0);
    if (s.available() > 0)
        info += s.readString();
        
    infoArea.setText("_" + info);
}

void sendMessage() {
    s.write(gui.get(Textfield.class, "manualInput").getText() + "\n");
}
