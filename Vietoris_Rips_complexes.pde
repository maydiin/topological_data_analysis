IntList list;
float slider_width = 50;
float slider_height = 10;
float posx, posy;
boolean over = false;
boolean locked = false;
float xoff;
float fundo;
void setup() {
  size(1000, 850);
  background(50);
  list= new IntList();
  posx = 70;
  posy = height/10;
  rectMode(CENTER);
  stroke(255);
  line (50, posy, posx+900, posy);
}

void draw() {
  fundo = posx;
  background(50);
  line (100, posy, 900, posy);
  if (dist(mouseX, mouseY, posx, posy) < slider_height) {
    fill(200);
    over = true;
  } else {
    fill(255);
    over = false;
  }


  if (posx < 70) {
    posx = 70;
  }

  if (posx > 900) {
    posx = 900;
  }


  rect(posx, posy, slider_width, slider_height);

  for (int k = 0; k < list.size()-1; k +=2 ) {
    fill(204, 102, 0);
    circle(list.get(k), list.get(k+1), 5);
    noFill();
    strokeWeight(1);
    circle(list.get(k), list.get(k+1), posx/2);

    for (int i = 0; i < list.size()-1; i +=2 ) {
      if (dist(list.get(k), list.get(k+1), list.get(i), list.get(i+1))<posx/2) {
        strokeWeight(1);
        stroke(200);
        line(list.get(k), list.get(k+1), list.get(i), list.get(i+1));
        for (int j = i+2; j < list.size()-1; j +=2 ) {
          if ((dist(list.get(i), list.get(i+1), list.get(j), list.get(j+1))<posx/2)&&
            (dist(list.get(k), list.get(k+1), list.get(j), list.get(j+1))<posx/2)) {
            fill(255, 255, 255, 50);
            triangle(list.get(k), list.get(k+1), list.get(j), list.get(j+1), list.get(i), list.get(i+1));
          }
        }
      }
    }
  }
  
  noLoop();
}

void mousePressed() {
  if (over) {
    locked = true;
    xoff = mouseX-posx;
  }
  if (mouseY>150) {
    stroke(255);
    list.append(pmouseX);
    list.append(pmouseY);
  }
  loop();
}
void mouseDragged() {
  if (locked) {
    posx = mouseX-xoff;
  }
  loop();
}
void mouseReleased() {
  locked = false;
  noLoop();
}
