/* @pjs preload="FireEquipment.jpg"; */
/* @pjs preload="colorwheel.png"; */

color backgroundColor;

ImageAnalyzer imageAnalyzer;
ColorWheel colorWheel;

void setup() {
  size(1050,500);
  backgroundColor = color(100,100,100,0);
  background(backgroundColor);
  
  //This color mode allows for plotting in the colorwheel
  colorMode(HSB,TWO_PI,1.0,1.0);
  
  smooth();
  
  colorWheel = new ColorWheel("colorwheel.png");
  imageAnalyzer = new ImageAnalyzer("FireEquipment.jpg");
  
  imageAnalyzer.initScan();
  
    
}

void draw(){
  colorWheel.render();
  pushMatrix();
  translate(imageAnalyzer.getWidth()+50,0);
  imageAnalyzer.render();
  popMatrix();
  if(imageAnalyzer.isScanning()){
    colorWheel.receiveScan(imageAnalyzer.scan());   
  }

}




class ImageAnalyzer{
  //Loaded image, unaltered
  PImage originalImage;
  
  //Color changed image
  PImage alteredImage;
  
  //Single row image to show 'scanning line'
  PImage scanLine;
  int scanningRow;
  
  //Dark overlay to show unscanned image
  PGraphics overlay;
  
  boolean scanning;
  
  ImageAnalyzer(String fileName){
    originalImage = loadImage(fileName); 
    scanning = false;
  }
  
  void initScan(){
    scanning = true;
    scanLine = createImage(originalImage.width, 1, RGB);
    overlay = createGraphics(originalImage.width, originalImage.height,P2D);
    overlay.beginDraw();
    overlay.noStroke();
    overlay.fill(0,0,0,200);
    overlay.rect(0,0,originalImage.width,originalImage.height);
    overlay.endDraw();
  }
  
  int[] scan(){
      originalImage.loadPixels();
      scanLine.loadPixels();
      color scanColor;
      for(int i = 0; i < originalImage.width; i++){
        scanLine.pixels[i]= color(hue(originalImage.pixels[originalImage.height*scanningRow+i]),saturation(originalImage.pixels[originalImage.height*scanningRow+i]),1.0);
      }
      originalImage.updatePixels();
      scanLine.updatePixels();
      scanningRow++;
      
      overlay.beginDraw();
      overlay.noStroke();
      overlay.background(0,0,0,0);
      overlay.fill(0,0,0,200);
      overlay.rect(0,scanningRow,originalImage.width,originalImage.height-scanningRow);
      overlay.endDraw();
      
      if(scanningRow >= originalImage.height){
        scanning = false;
      }
      
      return scanLine.pixels;
  }
  
  void render(){
    image(originalImage,0,0);
    if(scanning){
      image(overlay,0,0);
      image(scanLine,0,scanningRow-1); 
      image(scanLine,0,scanningRow); 
      image(scanLine,0,scanningRow+1); 
    }
  }
  
  int getWidth(){
    return originalImage.width;
  }
  
  int getHeight(){
    return originalImage.height; 
  }
  
  boolean isScanning(){
    return scanning; 
  }
}

class ColorWheel{
  PImage bg;
  GamutMask gm;
 
  ColorWheel(String fileName){
    bg = loadImage(fileName); 
    gm = new GamutMask(500,500);//bg.width,bg.height);
  }
  
  
  
  void render(){
    image(bg,0,0);
    gm.render();
  }
  
  void receiveScan(int[] scannedPixels, int w){
    gm.receiveScan(scannedPixels,w);  
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
  PImage overlay;
  int d;
  int r;
  PVector center;
  
  PVector[] colorPlots;
  
  GamutMask(int w, int h){
    d = w;
    r = round(w/2);
    center = new PVector(r,r);
    pg = createGraphics(w,h, P2D);
    pg.beginDraw();
    pg.noStroke();
    pg.fill(0,0,0,200);
    pg.ellipse(w/2, h/2, w, h);
    pg.endDraw();
    
    pg.loadPixels();
    overlay = pg;
  }
  
  void receiveScan(int[] scannedPixels, int w){
      
  }

  void render(){
    image(overlay,0,0);
  }  
}
