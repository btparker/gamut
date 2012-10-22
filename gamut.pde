/* @pjs preload="FireEquipment.jpg"; */

color backgroundColor;

ImageAnalyzer imageAnalyzer;
ColorWheel colorWheel;

void setup() {
  size(1000,500);
  backgroundColor = color(100,100,100,0);
  background(backgroundColor);
  
  //This color mode allows for plotting in the colorwheel
  colorMode(HSB,TWO_PI,1.0,1.0);
  
  smooth();
  
  colorWheel = new ColorWheel("colorwheel.png");
  imageAnalyzer = new ImageAnalyzer("FireEquipment.jpg");
}

void draw(){
  colorWheel.render(new PVector(0,0));
  imageAnalyzer.render(new PVector(imageAnalyzer.getWidth(),0));
}




class ImageAnalyzer{
  PImage activeImage;
  PImage scanLine;
  int scanningRow;
  
  ImageAnalyzer(String fileName){
    activeImage = loadImage(fileName); 
    scanLine = createImage(activeImage.width, 1, RGB);
  }
  
  int[] scan(){
      activeImage.loadPixels();
      scanLine.loadPixels();
      color scanColor;
      for(int i = 0; i < activeImage.width; i++){
        scanLine.pixels[i]= color(hue(activeImage.pixels[activeImage.height*scanningRow+i]),saturation(activeImage.pixels[activeImage.height*scanningRow+i]),1.0);
      }
      activeImage.updatePixels();
      scanLine.updatePixels();
      scanningRow++;
      
      return scanLine.pixels;
  }
  
  void render(PVector pos){
    image(activeImage,pos.x,pos.y);
  }
  
  int getWidth(){
    return activeImage.width;
  }
  
  int getHeight(){
    return activeImage.height; 
  }
}

class ColorWheel{
  PImage bg;
  GamutMask gm;
 
  ColorWheel(String fileName){
    bg = loadImage(fileName); 
    gm = new GamutMask(500,500);
  }
  
  void render(PVector pos){
    image(bg,pos.x,pos.y);
    gm.render(pos.x,pos.y);
  }
  
  int getWidth(){
    return bg.width;
  }
  
  int getHeight(){
    return bg.height; 
  }
}

class GamutMask{
  PGraphics pg;
  
  GamutMask(int inX, int inY){
    pg = createGraphics(inX,inY, P2D);
    pg.beginDraw();
    pg.noStroke();
    pg.fill(0,0,0,200);
    pg.ellipse(pg.width/2,pg.height/2,pg.width,pg.height);
    pg.endDraw();
  }

  void render(int posX, int posY){
    
    image(pg,posX,posY);
  }  
}
