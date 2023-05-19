FloatList list;
float slider_width = 50;
float slider_height = 10;
float posx, posy;
boolean over = false;
boolean locked = false;

float xoff;
void setup() {
  size(1000, 850);
  background(50);
  list= new FloatList();
  posx = 70;
  posy = height/10;
  rectMode(CENTER);
  stroke(255);
  line (30, posy, posx+900, posy);
}

void draw() {
  background(50);
  stroke(255);
  line (70, posy, 900, posy);

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

  for (int k = 0; k < list.size(); k +=2 ) {
    fill(0, 255, 0);
    strokeWeight(0);
    ellipse(list.get(k), list.get(k+1), 5, 5);
    for (int m = k+2; m < list.size(); m +=2 ) {
      for (int n = m+2; n < list.size(); n +=2 ) {
        float[] tri_circle= create_circle_w_three_point(list.get(k), list.get(k+1), list.get(m), list.get(m+1), list.get(n), list.get(n+1));

        noFill();
        //ellipse(tri_circle[0], tri_circle[1], tri_circle[2]*2, tri_circle[2]*2);
        boolean tri=true;
        for (int c=0; c< list.size(); c+=2) {

          if (dist(tri_circle[0], tri_circle[1], list.get(c), list.get(c+1))<tri_circle[2]-0.01) {
            tri= false;
          }
        }
        if (tri==true) {
          noFill();
          strokeWeight(0);
          stroke(0, 200, 0);
          ellipse(tri_circle[0], tri_circle[1], tri_circle[2]*2, tri_circle[2]*2);
          if (dist(list.get(k), list.get(k+1), list.get(m), list.get(m+1))<posx) {
            strokeWeight(1);
            line(list.get(k), list.get(k+1), list.get(m), list.get(m+1));
            double[] sd =circleCircleIntersects(list.get(k), list.get(k+1), list.get(m), list.get(m+1), posx/2, posx/2);
            float[] s = new float[4];
            if (sd != null) {

              for (int p = 0; p < 4; p++) {
                s[p] = (float)sd[p];
              }
            }
            if (dist(list.get(n), list.get(n+1), s[0], s[1])<posx/2-0.01 || dist(list.get(n), list.get(n+1), s[2], s[3])<posx/2-0.01) {
              fill(0, 100, 0, 80);
              triangle(list.get(m), list.get(m+1), list.get(k), list.get(k+1), list.get(n), list.get(n+1));
            }
          }
          strokeWeight(1);
          if (dist(list.get(k), list.get(k+1), list.get(n), list.get(n+1))<posx) {
            line(list.get(k), list.get(k+1), list.get(n), list.get(n+1));
          }
          if (dist(list.get(m), list.get(m+1), list.get(n), list.get(n+1))<posx) {
            line(list.get(m), list.get(m+1), list.get(n), list.get(n+1));
          }
          noFill();
          stroke(200, 200, 0);
          strokeWeight(0);
          ellipse(list.get(k), list.get(k+1), posx, posx);
          ellipse(list.get(m), list.get(m+1), posx, posx);
          ellipse(list.get(n), list.get(n+1), posx, posx);
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


public float[] create_circle_w_three_point(float x1, float y1, float x2, float y2, float x3, float y3) {
  float[] inter_circle = new float[3];
  float x0 = ((pow(x1, 2) + pow(y1, 2)) * (y2 - y3) + (pow(x2, 2) + pow(y2, 2)) * (y3 - y1) + (pow(x3, 2) + pow(y3, 2)) * (y1 - y2)) / (2 * (x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2)));
  float y0 = ((pow(x1, 2) + pow(y1, 2)) * (x3 - x2) + (pow(x2, 2) + pow(y2, 2)) * (x1 - x3) + (pow(x3, 2) + pow(y3, 2)) * (x2 - x1)) / (2 * (x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2)));

  float r = sqrt(pow((x1 - x0), 2) + pow((y1 - y0), 2));
  inter_circle[0]=x0;
  inter_circle[1]=y0;
  inter_circle[2]=r;
  return inter_circle;
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
