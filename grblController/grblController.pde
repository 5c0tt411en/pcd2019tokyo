import processing.serial.*;
import controlP5.*;

Serial s = null;
ControlP5 gui = null;
Textarea infoArea, gcodeArea;
Slider2D s2d;

String portName = "/dev/tty.wchusbserial1410";
String info = "";
String[] gcode = {""};
String gcodeInfo = "";
String filePath = "no file selected yet.";
Boolean isRealtime = false;

void setup() {
    size(800, 600);
    s = new Serial(this, portName, 115200);

    gui = new ControlP5(this);
    gui.addButton("file_open")
        .setPosition(20, 20);
    gui.addButton("run")
        .setPosition(90, 20);
    gui.addTextfield("manualInput")
        .setPosition(20, 60);
    gui.addButton("sendMessage")
        .setPosition(80, 90);
    gui.addButton("status")
        .setPosition(20, 120);
    gui.addButton("config")
        .setPosition(90, 120);
    gui.addButton("unlock")
        .setPosition(20, 140);
    gui.addButton("home")
        .setPosition(90, 140);
    gui.addButton("homing")
        .setPosition(160, 140);
    gui.addRadioButton("type")
        .setPosition(20, 180)
        .setSize(20, 20)
        .setColorForeground(color(120))
        .setColorActive(color(255))
        .setColorLabel(color(255))
        .setItemsPerRow(5)
        .setSpacingColumn(50)
        .addItem("realtime", 1)
        .addItem("not realtime", 2)
        ;
    s2d = gui.addSlider2D("manual_position")
        .setPosition(20, 210)
        .setSize(210, 297)
        .setMaxX(210)
        .setMaxY(297)
        .setArrayValue(new float[] {50, 50});

    gui.addToggle("servo")
        .setPosition(20, 550);
        
    infoArea = gui.addTextarea("statusInfo")
        .setPosition(250, 20)
        .setSize(200, 500)
        .setLineHeight(14)
        .setColor(color(128))
        .setColorBackground(color(255, 100))
        ;
    infoArea.setText(info);
    gcodeArea = gui.addTextarea("gcodeInfo")
        .setPosition(460, 20)
        .setSize(200, 500)
        .setLineHeight(14)
        .setColor(color(128))
        .setColorBackground(color(255, 100))
        ;
    infoArea.setText(info);
}

void draw() {
    background(0);

    if (s.available() > 0) {
        info += s.readString();
    }
    infoArea.setText("_" + info);

    gcodeArea.setText(gcodeInfo);

    if (isRealtime) {
        s.write("G90 G0 X" + s2d.getArrayValue()[0] + " Y" + s2d.getArrayValue()[1] + "\n");
    }
}

void file_open() {
    selectInput("Select a file to process:", "fileSelected");
}

void sendMessage() {
    s.write(gui.get(Textfield.class, "manualInput").getText() + "\n");
}

void status() {
    info = "";
    s.write("?\n");
}

void unlock() {
    info = "";
    s.write("$X\n");
}

void config() {
    info = "";
    s.write("$$\n");
}

void home() {
    info = "";
    s.write("G90 G0 X0 Y0\n");
}

void homing() {
    info = "";
    s.write("$H\n");
}

void run() {
    info = "";
    for (int i = 0; i < gcode.length; i++) {
        s.write(gcode[i] + "\n");
    }
}

void type(int a) {
    s.write("$X\n");
    isRealtime = (a == 1 ? true : false);
}

void servo(boolean theFlag) {
    s.write("$X\n");
    if (theFlag==true) {
        s.write("M03 S900\n");
    } else {
        s.write("M03 S500\n");
    }
}

void fileSelected(File selection) {
    gcodeInfo = "";
    if (selection == null) {
        gcodeInfo = "Window was closed or the user hit cancel.";
    } else {
        gcodeInfo = "User selected " + selection.getAbsolutePath() + "\n\ncode:\n---------------\n";
        gcode = loadStrings(selection.getAbsolutePath());        
        for (int i = 0; i < gcode.length; i++) {
            s.write(gcode[i] + "\n");
            delay(50);
            gcodeInfo += gcode[i] + "\n";
        }
    }
}
