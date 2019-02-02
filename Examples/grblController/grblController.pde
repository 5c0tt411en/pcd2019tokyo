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
String[] st, st_;

void setup() {
    size(800, 600);
    s = new Serial(this, portName, 115200);
    delay(3000);

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
        delay(30);
        info += s.readString();
    }
    infoArea.setText("_" + info);

    gcodeArea.setText(gcodeInfo);

    if (isRealtime) {
        s.write("G90 G0 X" + s2d.getArrayValue()[0] + " Y" + s2d.getArrayValue()[1] + "\n");
    }
    blendMode(ADD);
    ellipse(20 + getPos()[0], 210 + getPos()[1], 10, 10);
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
        s.write("M03 S300\n");
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
            //if (getStatus().equals("idle")){
            //}
            s.write(gcode[i] + "\n");
            delay(2000);
            gcodeInfo += gcode[i] + "\n";
        
            }
    }
}

String getStatus() {
    String status = "";
    s.write("?\n");
    delay(30);
    if (s.available() > 0) {
        st = split(s.readString(), '|');
        if (st.length >= 1)
            st_ = split(st[0], '<');
        if (st.length >= 2)
            status = st_[1];
    }
    return status;
}

float[] getPos() {
    float[] p = new float[]{0, 0};
    s.write("?\n");
    delay(30);
    if (s.available() > 0) {
        st = split(s.readString(), ':');
        if (st.length >= 2)
            st_ = split(st[1], ',');
        if (st_.length >= 2)
            p = new float[]{float(st_[0]), float(st_[1])};
    }
    return p;
}
