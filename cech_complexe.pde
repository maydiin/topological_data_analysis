FloatList list;
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
  list= new FloatList();
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
    ellipse(list.get(k), list.get(k+1), 5, 5);
    noFill();
    strokeWeight(1);
    ellipse(list.get(k), list.get(k+1), posx, posx);

    for (int i = k+2; i < list.size()-1; i +=2 ) {
      if (dist(list.get(k), list.get(k+1), list.get(i), list.get(i+1))<posx) {
        strokeWeight(1);
        stroke(200);
        line(list.get(k), list.get(k+1), list.get(i), list.get(i+1));

        for (int m=i+2; m<list.size()-1; m+=2) {
          double[] sd =circleCircleIntersects(list.get(k), list.get(k+1), list.get(i), list.get(i+1), posx/2, posx/2);
          float[] s = new float[4];
          if (sd != null) {

            for (int p = 0; p < 4; p++) {
              s[p] = (float)sd[p];
            }
          }
          if (dist(list.get(m), list.get(m+1), s[0], s[1])<posx/2 || dist(list.get(m), list.get(m+1), s[2], s[3])<posx/2) {
            fill(200,200,200,50);
            triangle(list.get(m), list.get(m+1), list.get(k), list.get(k+1), list.get(i), list.get(i+1));
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
}
void mouseDragged() {
  if (locked) {
    posx = mouseX-xoff;
  }
  loop();
}
void mouseReleased() {
  locked = false;
  loop();
}


public double[] circleCircleIntersects(double x1, double y1, double x2, double y2, double r1, double r2)
{
  
  double a = x2 - x1;
  double b = y2 - y1;

  double ds = a*a + b*b;
  double d = Math.sqrt( ds );

  
  if (r1 + r2 <= d)
    return null;

  
  if (d <= Math.abs( r1 - r2 ))
    return null;

  
  double t = Math.sqrt( (d + r1 + r2) * (d + r1 - r2) * (d - r1 + r2) * (-d + r1 + r2) );

  double sx1 = 0.5 * (a + (a*(r1*r1 - r2*r2) + b*t)/ds);
  double sx2 = 0.5 * (a + (a*(r1*r1 - r2*r2) - b*t)/ds);

  double sy1 = 0.5 * (b + (b*(r1*r1 - r2*r2) - a*t)/ds);
  double sy2 = 0.5 * (b + (b*(r1*r1 - r2*r2) + a*t)/ds);

  
  sx1 += x1;
  sy1 += y1;

  sx2 += x1;
  sy2 += y1;

  double[] r = new double[4];
  r[0] = sx1;
  r[1] = sy1;
  r[2] = sx2;
  r[3] = sy2;

  return r;
}
