/* @pjs preload="FireEquipment.jpg,colorwheel.png"; */

color backgroundColor;

ImageLoader imageLoader;
PImage colorWheel;
GamutMask gamutMask;

static final int OVERLAY_OPACITY = 200;

void setup() {
  size(1050,500);
  backgroundColor = color(100,100,100,0);
  background(backgroundColor);
  
  //This color mode allows for plotting in the colorwheel
  colorMode(HSB,TWO_PI,1.0,1.0);
  
  smooth();
  
  colorWheel = loadImage("colorwheel.png");
  imageLoader = new ImageLoader("FireEquipment.jpg", colorWheel.width, colorWheel.height);
  
  //scan();
    
}

void uploadImage(String filename){
  background(backgroundColor);
  imageLoader = new ImageLoader(filename, colorWheel.width, colorWheel.height);  
  gamutMask = null;
}

void scanImage(){
  gamutMask = new GamutMask(colorWheel.width,colorWheel.height,imageLoader.getImage());
}

void draw(){
  image(colorWheel,0,0);
  if(gamutMask){
    gamutMask.render();
  }
  pushMatrix();
  translate(colorWheel.width+50,0);
  imageLoader.render();
  popMatrix();

}




class ImageLoader{
  //Loaded image, unaltered
  PImage img;
  int w,h;
  int sw,sh;
  int tx,ty;
  
  
  ImageLoader(String fileName,int w, int h){
    img = loadImage(fileName);
    this.w = w;
    this.h = h;
    
        
  }
  
  PImage getImage(){
    return img;  
  }

  void render(){
    if(!sh){
      sh = w*img.height/img.width;
      sw = w;
      if(sh > h){
        sh = h;
        sw = h*img.width/img.height;
      }
    
      tx = round((w-sw)/2.0);
      ty = round((h-sh)/2.0);
    }
    image(img,tx,ty,sw,sh);
  }
}

class GamutMask{
  PGraphics pg;
  PImage overlay;
  PImage img;
  int d;
  int r;
  
  PVector center;
  
  PVector[] colorPlots;
  
  GamutMask(int w, int h, PImage img){
    this.img = img;
    d = w;
    r = round(w/2);
    center = new PVector(r,r);
    pg = createGraphics(w,h, P2D);
    pg.beginDraw();
    pg.noStroke();
    pg.fill(0,0,0,OVERLAY_OPACITY);
    pg.ellipse(w/2, h/2, w, h);
    pg.endDraw();
    
    pg.loadPixels();
    overlay = pg;
    
    colorPlots = new PVector[img.width*img.height];
    overlay.loadPixels();
    img.loadPixels();
    for(int j = 0; j < img.height; j++){
      for(int i = 0; i < img.width; i++){
        plotColor(img.pixels[j*img.width+i]);
      } 
    }   
    img.updatePixels();
    overlay.updatePixels();
  }
  
  void plotColor(int scannedColor){ 
    float angle = hue(scannedColor);
    float radial = saturation(scannedColor);
    
    float xUnitVal = radial*cos(angle);
    float yUnitVal = radial*sin(angle);
    
    float xVal = xUnitVal*d+center.x;
    float yVal = yUnitVal*d+center.y;
    
    
    overlay.set(xVal,yVal,color(0,0,0,0));
    
    
  }

  void render(){
    image(overlay,0,0);
  }  
}
