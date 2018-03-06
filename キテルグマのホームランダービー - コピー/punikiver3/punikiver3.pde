import processing.serial.*;
import ddf.minim.*;

Serial myPort1;

boolean kebosu_flg = false; //変化球フラグ
int kebosu = 0; //変化球
float x;
float y;
float y_kebosu6;
float dir_x = 1;
float dir_y = 1;
float r = 70;
float t = (PI/2)-(PI/6);
float l_x;//
float l_y;//
int speed = 7;// 東急依存
int Speed = 0;//スイング依存
int count = 0;//
int flag = -1;//ボールのフラグ
int imageCount = 0;
int hit = 0;
float bound_y;
int time = 0;
int imovex = 0;
int imovey = 0;
float dis = 0;
float result_x;
float result_y;
float result;
int X,Y,Z;//加速度センサ
int stop = 0;
int Flag =0;//ホームランのカウントを止めるために必要
int Gameendflag = 0;
int  trigger = 0;//音楽一回だけ流すため
/*投球数、ホームラン数を表示するための変数*/
int Hcount=0;
int Pcount=0;
int swingcount;
int slow;
int slowcount;
int SS = 10;
int TT = 0;
PImage[] number = new PImage[10];
int ten = 5;//10の位
int one = 0;//1の位
/*----------------------------------------*/

/*ロビカスの管理*/
PImage[] robikes = new PImage[12];
int m = 1;
int robitime = 0;
int robiflag = 0;

int c;
PImage img;
PImage Strike;
PImage Farl;
PImage Homerun;
PImage Hit;
PImage Menu;

PImage Crear;
PImage Over;

int numFrames = 7; 
PImage[] images = new PImage[numFrames]; //アニメーション画像の配列
PImage haikei;
int n=0;
int q = 0;
int p = 0;
int count2 = 0;//キテルグマ再生のフラグ管理用

int GameMode = 0;

Minim minim; //音の実装
AudioSample P; //サウンド「se」の宣言
AudioSample B; //サウンド「go」の宣言
AudioSample R; //サウンド「gs」の宣言
//AudioSample OP; //サウンド「pd」の宣言

AudioPlayer OP;
//AudioPlayer R;

void setup() {
  //Arduino
  //myPort1 = new Serial(this,"COM3",9600);
  
 // myport1.write(0);
//  myPort2 = new Serial(this, "COM4", 9600);
  //  noStroke();
  size( 620, 465 );
  frameRate( 30);

  haikei = loadImage("haikei.png");
  img = loadImage( "ball.png" );
  Strike = loadImage("strike.PNG");
  Farl = loadImage("farl.PNG");
  Homerun = loadImage("homerun.PNG");
  Hit = loadImage("hit.PNG");
  Menu = loadImage("menu.PNG");
  Crear = loadImage("gameclera.png");
  Over = loadImage("gameover.png");
  /*キテルグマの画像の読み込み*/
  for (int i = 1; i < images.length; i++) {
    images[i] = loadImage("kuma" + i + ".png");
  }
  /*数字の画像読み込み*/
  for (int j = 0; j < number.length; j++) {

    number[j] = loadImage(""+ j + ".PNG");
  }
  /*ロビカスの画像の読み込み*/
  for (int i = 1; i < robikes.length; i++) {

    robikes[i] = loadImage("robiks"+ i + ".png");
  }
  
    minim = new Minim(this);
   P = minim.loadSample("./P.mp3"); //ブロックにボールが当たった時に鳴るサウンド関数の宣言
   B = minim.loadSample("./B.mp3"); //ゲームオーバーになった時に鳴るサウンド関数の宣言
   R = minim.loadSample("./R.mp3"); //ゲームがスタートしたときに鳴るサウンド関数の宣言
   OP = minim.loadFile("./OP.mp3"); //ボールを打ち損じた時になるサウンド
   
     OP.loop();
}



void draw() {
  minim = new Minim(this);//ゲームのスタート音

  
if(GameMode == 0){
  Title();
}else{
  noCursor();
  background(haikei);
  number();//数字の画像を読み込みする関数

  //    println(X);
  image(images[1], 130+p, 220+q);
  image(robikes[1], 280, 0, 80, 140);

  /*ロビカス再生プログラム*/
  if (robiflag == 1) {
    background(haikei);
    number();
    robiksplay();
    kiterukuma();
  }else{
  m = 9;
}

  if (count2 == 1) {
    background(haikei);
    number();
    kiterukuma();//キテルグマの関数
  } else {
    n= 0;//初期状態に戻す
  }

  /*ボールの判定とか*/
  if (flag == 1) {
    x = 290;
    y += dir_y * speed;
    y_kebosu6 += dir_y * speed;
    if(kebosu == 0){ //変化球ナシ
      image( img, x, y, 25, 25);//ボールの画像
    }else if(kebosu == 1){
      for(int i = 0;i < 10; i++){
          image( img, x + cos(radians(random(360))) * random(50), y + sin(radians(random(360))) * random(50), 25, 25);//ボールの画像
      }
    }else if(kebosu == 2){
      image( img, x + cos(radians((float)y / height * 360)) * 20, y, 25, 25);//ボールの画像
    } else if(kebosu == 3){
      image( img, x - cos(radians((float)y / height * 360)) * 20, y, 25, 25);//ボールの画像
    }else if(kebosu == 4){
      if( y < height / 3 || y > height / 2 + 50){
        image( img, x, y, 25, 25);//ボールの画像
      }
    }else if(kebosu == 5){
        image( img, x + cos(x / 10.0) * 10, y + sin(y / 10.0) * 10, 25, 25);//ボールの画像
    }else if(kebosu == 6){
      if (y <= 465){
        speed = 14;
          if(y_kebosu6 < height / 3 * 2) y = -random(height);
//          テスト用
//          fill(255,0,0);
//          ellipse(x+12.5,y+12.5,25,25);
          for(int i = (int)y_kebosu6; i > 0; i -=25){
            image( img, x, i , 25, 25);//ボールの画像        
          }
      }
    }

  }
  if (flag == 0) {
    y -= dir_y * speed;
    x -= dir_x + speed;
    image( img, x, y, 25, 25);//ボールの画像
  }
 print(X*100);
     print(",");
    print(Y*100);
   print(",");
  println(Z*100); 
     if(X!=0&&Y!=0&&Z!=0&&count==0&&swingcount==0&&(X*100<7000||Y*100<7000||Z*100<7000)){
      count = 1;
      count2 = 1;
      swingcount=1;
      myPort1.write(1);
     }else{
     //Arduino  
     //myPort1.write(0);
     }
  if (count ==1 /*&& X >120*/) {
    if (t >= -TWO_PI/4 + PI/6) {
      t-=0.2;
      if(t < 0)t-=0.25;
      l_x = r * cos(t);
      l_y = r * sin(t);
    } else {
      count = 0;
      t=(PI/2)-(PI/12);
    }

//     line(250 ,300 ,l_x+250, l_y+300);
//     ellipse( 250 + l_x, 300 + l_y, 10, 10);
    if (300+l_y -30 <= y && 300+l_y  >= y && hit == 0) {
      B.trigger();
      Speed = 15;
      float bound_x = l_x;
      bound_y = -l_y;
      println(t);
      flag = 0;
      hit = 1;
      dir_x = (((bound_y * -Speed)/(-bound_x))) *2;
      //ファール判定
//      if (abs(dir_x) > ???){
//        
    }
  }

  if (hit == 1) {//距離の判定
    dis = sqrt(x*x + y*y);
    if(dis > Speed*100 && stop == 0){
    result_x = x;
    result_y = y;
    result = sqrt(result_x*result_x + result_y*result_y);
   // print(result);
    stop = 1;
    println(result);
    println(result_x);
    println(result/2 + result_x);
    println(y);
    }
  } else if (hit == 0)strike();
 
  if(Flag == 0 && stop == 1 && result/2 + result_x < 2250 && result/2 + result_x > -660){
    result = random(1480, 1550);
    if(result <1500){
      hit();
      Flag = 1;
    }else {
      homerun();
      number();
      Flag = 1;
     }
  }else if(result/2 + result_x >= 2250 || result/2 + result_x <= -660){
     farl();
     Flag = 1;
  } 
  //if(imageCount == 0)
  if(imageCount == 1){
    image(Homerun, width/4, 0);
    if(trigger == 0){
      R.trigger();
      trigger = 1;
    }
  }else if(imageCount == 2){
    image(Hit, width/4 + 50, 0);
    if(trigger == 0){
      R.trigger();
      trigger = 1;
    }
  }else if(imageCount == 3){
    image(Farl, width/4, 0);
    if(trigger == 0){
      R.trigger();
      trigger = 1;
    }
  }else if(imageCount == 4){
    image(Strike, width/4, 0);
    if(trigger == 0){
      R.trigger();
      trigger = 1;
    }
  }
}
if(Pcount == ten * 10 + one + 1){
  if(Hcount >= (ten - 1) * 10 + one){
  image(Crear, width/8 + 30, height/2);
  Gameendflag = 1;
  robiflag = 0;
}else{
  image(Over, width/8, height/2);
  Gameendflag = 1;
  robiflag = 0;
}
}
}

void strike() {
  if (y > 465)
    imageCount = 4;
}

void homerun() {
 
  /*ホームランだったらHcountを++してください*/
  Hcount++;
    TT++;
  if(TT == 10){
    TT = 0;
  } /*そしてTTをカウントして10になったら0に戻すように設定して*/
   imageCount = 1;
}
void hit() {
  imageCount =2;
}
void farl() {
  imageCount = 3;
}



void keyPressed() {
  if(key == 'k'){
    kebosu_flg = true;
    kebosu = 1;
    speed =7;
    swingcount = 0;
  }
  if(key == 'e'){
    kebosu_flg = true;
    kebosu = 2;
    speed = 22;
    swingcount = 0;
  }
  if(key == 'b'){
    kebosu_flg = true;
    kebosu = 3;
    speed = 22;
    swingcount = 0;
  }
  if(key == 'o'){
    kebosu_flg = true;
    kebosu = 4;
    swingcount = 0;
    speed =7;
  }
  if(key == 's'){
    kebosu_flg = true;
    kebosu = 5;
    swingcount = 0;
    speed =7;
  }
  if(key == 'u'){
    kebosu_flg = true;
    kebosu = 6;
    y_kebosu6 = 0;
    swingcount = 0;
    speed =7;
  }
  if(key == 'd'){
    kebosu_flg = true;
    speed += 3;
    if(speed > height) speed = height;
  }
  if(key == 'a'){
    kebosu_flg = true;
    speed -= 3;
    if(speed < 1) speed = 1;
  }
  
  if (key == 'r') {
    
    if(!kebosu_flg){
      kebosu = 0;
      speed = 7;
    }
    kebosu_flg = false;

    robiflag = 1;

    x = 290;
    y =0;
    dir_x = 1;
    dir_y = 1;
    r = 70;
    t = PI/2;
    Flag = 0;
    result_x = 0;
    result_y = 0;
    result = 0;
    imageCount = 0;
stop = 0;
swingcount = 0;
trigger = 0;
    /*残り投球数のカウント*/
    Pcount++;
    println(Pcount);
    SS--;
    if (SS==-1) {
      SS=9;
    }



    //count = 0;
    //flag = 1;//ボールの飛んでいく部分の判定

    hit = 0;

    imovex = 0;
    imovey = 0;

    n=0;
    q = 0;
    p = 0;
    if(Pcount == ten * 10 + one + 1){
      y = 1500;
      hit = 1;
      Flag = 1;
      background(haikei);
    }
    if(Gameendflag == 1)exit();
    
  }
}
void mousePressed() {
  count = 1;
  count2 = 1;
  GameMode = 1;
}

/*数字の画像を表示するための関数*/
void number() {
  /*目標の表示*/
  image(number[ten-1], 75, 25, 18, 18);
  image(number[one], 95, 25, 18, 18);

  /*残り投球数の表示*/
  if (Pcount<=0) {
    image(number[5], 75, 105, 18, 18);
    image(number[0], 95, 105, 18, 18);
  } else if (Pcount>=1 && Pcount<=10) {
    image(number[4], 75, 105, 18, 18);
    image(number[SS], 95, 105, 18, 18);
  } else if (Pcount>=11 && Pcount<=20) {
    image(number[3], 75, 105, 18, 18);
    image(number[SS], 95, 105, 18, 18);
  } else if (Pcount>=21 && Pcount<=30) {
    image(number[2], 75, 105, 18, 18);
    image(number[SS], 95, 105, 18, 18);
  } else if (Pcount>=31 && Pcount<=40) {
    image(number[1], 75, 105, 18, 18);
    image(number[SS], 95, 105, 18, 18);
  } else if (Pcount>=41 && Pcount<=50) {
    image(number[SS], 95, 105, 18, 18);
  } else {
    image(number[0], 95, 105, 18, 18);
  }

  /*ホームラン数の表示*/
  if (Hcount>=0 && Hcount<=9) {
    image(number[TT], 95, 65, 18, 18);
  } else if (Hcount>=10 && Hcount<=19) {
    image(number[1], 75, 65, 18, 18);
    image(number[TT], 95, 65, 18, 18);
  } else if (Hcount>=20 && Hcount<=29) {
    image(number[2], 75, 65, 18, 18);
    image(number[TT], 95, 65, 18, 18);
  } else if (Hcount>=30 && Hcount<=39) {
    image(number[3], 75, 65, 18, 18);
    image(number[TT], 95, 65, 18, 18);
  } else if (Hcount>=40 && Hcount<=49) {
    image(number[4], 75, 65, 18, 18);
    image(number[TT], 95, 65, 18, 18);
  } else if (Hcount>=50) {
    image(number[5], 75, 65, 18, 18);
    image(number[0], 95, 65, 18, 18);
  } else {
    image(number[5], 75, 65, 18, 18);
    image(number[0], 95, 65, 18, 18);
  }
}

void kiterukuma(){
  image(images[1], 130+p, 220+q);
 

  if (count2 == 1) {
  /*キテルグマの画像の位置調整(画像の大きさがガバガバなので調整)*/
    background(haikei);
    image(robikes[11], 280, 0, 80, 140);
    number();
  time++;
  n = 1;
    if (time <= 2) {
      p = -55;
      q = -35;
      n = 2;
    } else if (time > 2 && time <= 4) {
      p = -70;
      q = -60;
      n = 3;
    } else if (time > 4 && time <= 6) {
      p = -70;
      q = -75;
      n = 4;
    } else if (time > 6 && time <= 8) {
      p = -50;
      q = -60;
      n = 5;
    } else if (time > 8 && time <= 10) {
      p = -70;
      q = -60;
      n = 6;
    }
     image(images[n], 180+p, 260+q);
  }else{
    n = 0;
  }
    /*画像が最後まで行ったら初期状態に戻す*/
    if (n==6) {
      n = 1;
      count2 = 0;
      time = 0;
    }
    
    p = 0;
    q = 0;
  } 

void robiksplay(){
  kiterukuma();
  if(robiflag == 1){
    flag = -1;
    m = 1;
    robitime++;

    if (robitime <= 3) {
      m=2;
    } else if (robitime > 3 && robitime <= 6) {
      m=3;
    } else if (robitime > 6 && robitime <= 9) {
      m=4;
      P.trigger();
    } else if (robitime > 9 && robitime <= 12) {
      m=5;
    } else if (robitime > 12&& robitime <= 15) {
      m=6;
    } else if (robitime > 15 && robitime <= 18) {
      m=7;
    } else if (robitime > 18 && robitime <= 21) {
      m=8;
    } else if (robitime > 21 && robitime <= 27) {
      m=9;
    } else if (robitime > 27 && robitime <= 30) {
      m=10;
    } else if (robitime > 30 && robitime <= 33) {
      m=11;
    }
    image(robikes[m], 280, 0, 80, 140);
    
    if(m >= 9)flag =1;
    
    if(m==11){
      m = 11;
      robiflag = 0;
      robitime = 0;
      flag = 1;
      
    }
  }
}

void serialEvent(Serial p){
        
    if(myPort1.available()>2){
    X = myPort1.read();
    Y = myPort1.read();
    Z = myPort1.read();
    }
}
void Title(){
   background(Menu);
}
void stop()
{
  R.close();  //サウンドデータを終了
  OP.close();
}

void ball(){
  
}