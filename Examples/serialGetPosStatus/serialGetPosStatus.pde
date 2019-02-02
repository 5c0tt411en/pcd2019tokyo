import processing.serial.*;
import controlP5.*;

Serial s;
ControlP5 gui;

String portName = "/dev/tty.wchusbserial1410";
String[] st, st_;

void setup() {
    size(800, 600);
    s = new Serial(this, portName, 115200);
    delay(3000);

    gui = new ControlP5(this);
    gui.addTextfield("manualInput")
        .setPosition(20, 60);
    gui.addButton("sendMessage")
        .setPosition(80, 90);
}

void draw() {
    background(0);
    ellipse(getPos()[0], getPos()[1], 100, 100);
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
