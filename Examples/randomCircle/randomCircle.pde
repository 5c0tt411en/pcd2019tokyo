import processing.serial.*;
import controlP5.*;

Serial s;
ControlP5 gui;

String portName = "/dev/tty.wchusbserial1410";
String[] st, st_;

float time = 0, timeStamp = 0;
int mode = 0;
int[] randomLine;

void setup() {
    size(800, 600);
    s = new Serial(this, portName, 115200);
    delay(3000);
    s.write("$X\n");

    gui = new ControlP5(this);
    gui.addTextfield("manualInput")
        .setPosition(20, 60);
    gui.addButton("sendMessage")
        .setPosition(80, 90);
}

void draw() {
    background(0);
    ellipse(getPos()[0], getPos()[1], 100, 100);
    time = float(millis()) / 1000 - timeStamp;
    switch (mode) {
    case 0: 
        if (time >= 10.0) {
            randomLine = new int[]{
                (int)random(200), (int)random(250), (int)random(200), (int)random(250)};
            mode = 1;
            timeStamp = float(millis()) / 1000;
            s.write("M03 S300\n");
            delay(500);
            s.write("G90 G2 X" + str(randomLine[0]) + " Y" + str(randomLine[1]) + "\n");
        }
        break;
    case 1:
        if (time >= 10.0) {
            mode = 0;
            timeStamp = float(millis()) / 1000;
            s.write("M03 S900\n");
            delay(500);
            s.write("G90 G0 X" + str(randomLine[2]) + " Y" + str(randomLine[3]) + "\n");
        }
        break;
    }
}

void sendMessage() {
    s.write(gui.get(Textfield.class, "manualInput").getText() + "\n");
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
