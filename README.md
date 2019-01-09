# PCD 2019 Tokyo Workshop(Device Control)
今回講師をさせていただく，Processingユーザーの交流イベント"Processing Community Day 2019 Tokyo"(PCD 2019 Tokyo)のデバイス制御のレポジトリ．
私のワークショップではプロッターやレーザーカッター，3Dプリンタにも使用されているgrblを用いてドローイングロボットを制御します．今後のみなさまの制作の足がかりとなるよう，ドローイングに限らない汎用的な実践にしたいと思っています．
ディスプレイ外でのドローイングや作品制作に興味がある方は是非一緒に遊びましょう！

## Arduino grbl Library(ArduinoGrblLibrary_PCD/)
今回のワークショップの実機は一つのプーリーベルトに2角ステッピングモーターが取り付けられているタイプで，意図した座標に移動するために， ArduinoGrblLibrary_PCD/grbl/cgode.c 内を以下のように書き換えています．
```
xにa[mm]進む->(a, -a)
yにb[mm]進む->(b, b)
```
モーターが分離されている通常の場合は，配布されているライブラリのまま実装してください．

## grbl setting(grblSetting_PCD.txt)
```
$0=10
$1=25
$2=0
$3=0
$4=0
$5=0
$6=0
$10=19
$11=0.010
$12=0.002
$13=0
$20=0
$21=1
$22=1
$23=3
$24=100.000
$25=2000.000
$26=250
$27=5.000
$30=1000
$31=0
$32=0
$100=80.000
$101=80.000
$102=80.000
$110=3000.000
$111=3000.000
$112=3000.000
$120=900.000
$121=900.000
$122=900.000
$130=310.000
$131=220.000
$132=200.000
```

# grbl controller(grblController/grblController.pde)
![plot](images/plotTest.png)
![GUI](images/grblControllerGUI.png)

## TODO
- limit switch attaching for homing cycle
- gcode stack problem
- touch panel input for signiture drawing
