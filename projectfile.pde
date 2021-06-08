// General API info
String apiKey = "?key=dKjGWf9g";
String base = "https://www.rijksmuseum.nl/api/en/collection/SK-";
String[] collectionNumber = {"C-5", "C-251", "C-6", "A-2344", "A-2860", "A-1595", "A-133", "C-229", "A-4823", "A-385", "C-211", "A-4", "A-3262"};

// General JSON variables
JSONObject fullArtObject;
String url;
JSONObject artObject;
JSONArray colorsArray;

// Colors
JSONObject colorsArrayElement;
String[][] myColorArray = new String[collectionNumber.length][6];
int[][] unhexedColor = new int[collectionNumber.length][6];
String hexedColor;
int colorPaletteNumber = 0;

// The main painting
JSONObject webImage;
String[] mainImageURL = new String[collectionNumber.length];
int[] mainImageWidth = new int[collectionNumber.length];
int[] mainImageHeight = new int[collectionNumber.length];
PImage[] mainImageDisplay = new PImage[collectionNumber.length];
int imageNumber = 0;

// Paintings' names
String[] paintingNames = new String[collectionNumber.length];

// text position
int[] verticalPosition = {height/2 + 200, height/2 + 220, height/2 + 240, height/2 + 260, height/2 + 280, height/2 + 300};

// Booleans for states
Boolean introPage = true;
Boolean inspoPage = false;

// Font
PFont font;

void setup(){
  surface.setResizable(true);
  size(1100,800);
  getData();
  font = loadFont("Futura-CondensedMedium-48.vlw");
  
  for(int i = 0; i < collectionNumber.length; i++){
    mainImageDisplay[i] = loadImage(mainImageURL[i], "png");
    mainImageDisplay[i].resize((int)(mainImageWidth[i] * 0.15), (int)(mainImageHeight[i] * 0.15));
  }
}

void draw(){
  translate(width/2, height/2);
  background(24,23,22);
  rectMode(CENTER);
  imageMode(CENTER);
  textAlign(CENTER);
  
  if(introPage){
    stroke(221, 214, 190);
    if(mouseX > width/2 - width/4 && mouseX < width/2 + width/4 && mouseY > height/2 -.2 * height && mouseY < height/2 + .2 * height){
      fill(221, 214, 190, 50);
    }else{
      noFill();
    }
    rect(0,0, width/4, .2 * height);
   
    line(-300, -300, 300, -300);
    line(-300, 300, 300, 300);
    
    textFont(font);
  
    fill(221, 214, 190);
    text("Click for\ninspiration", 0,-15);
  }
  
  if(inspoPage){
    // showing the color palette
    noStroke();
    for(int j = 0; j < 6; j++){
      fill(unhexedColor[colorPaletteNumber][j]);
      rect(j*100 - 250, .2 * height, 100, 100);
      //if(mouseX > j*100 - 270 - 50 && mouseX < j*100 - 270 + 50 && mouseY < .2 * height - 50 && mouseY > .2 * height + 50){
      fill(221, 214, 190);
      textSize(20);
      text(myColorArray[colorPaletteNumber][j], 0, verticalPosition[j]);
      //}
    }
    textSize(20);
    text(paintingNames[imageNumber], 0, 100);
    image(mainImageDisplay[imageNumber], 0, - .2 * height);
     
    textSize(30);
    if(mouseX > width/2 + .35 * width - width/5 && mouseX <  width/2 + .35 * width + width/5 && mouseY > height/2 + .4 * height - .15 * height && mouseY < height/2 + .4 * height + .15 * height){
       fill(221, 214, 190, 50);
    }else{
    noFill();}
    
    stroke(221, 214, 190);
    rect(.35 * width, .4 * height, width/5, .15 * height);
    
    fill(221, 214, 190);
    text("Click for more\ninspiration", .35 * width, .4 * height - 10);
    
  
  }
  
  
}

void mousePressed(){
  println(mouseX, mouseY);
  
  if(mouseX > width/2 - width/4 && mouseX < width/2 + width/4 && mouseY > height/2 -.2 * height && mouseY < height/2 + .2 * height){
    inspoPage = true;
    introPage = false;
    println("Mouse clicked in the right location");
  }
  
  if(mouseX > width/2 + .35 * width - width/5 && mouseX <  width/2 + .35 * width + width/5 && mouseY > height/2 + .4 * height - .15 * height && mouseY < height/2 + .4 * height + .15 * height){
    imageNumber++;
    colorPaletteNumber++;
    
    if(collectionNumber.length <= imageNumber){
      imageNumber = 0;
    }
    
    if(collectionNumber.length <= colorPaletteNumber){
      colorPaletteNumber = 0;
    }
   
    println(imageNumber);
    println(colorPaletteNumber);
    redraw();
  }
  
}

void getData(){
  // Get the colors 
  for(int i = 0; i < collectionNumber.length; i++){
    
    url = base + collectionNumber[i] + apiKey;
    
    fullArtObject = loadJSONObject(url);
    println(fullArtObject);
    
    artObject = fullArtObject.getJSONObject("artObject"); 
    
    // Uploading names into a name array
    paintingNames[i] = artObject.getString("longTitle");
    
    colorsArray = artObject.getJSONArray("colors");
    // Uploading ALL the color data into a 2-D array (lines are for 6 principal colors of each painting and columns are for different paintings)
      for(int j = 0; j < 6; j++){
        colorsArrayElement = colorsArray.getJSONObject(j);
        myColorArray[i][j] = colorsArrayElement.getString("hex");
        hexedColor = "FF" + myColorArray[i][j].substring(2);
        unhexedColor[i][j] = unhex(hexedColor);
      }
    
    // Uploading all images at once
    webImage = artObject.getJSONObject("webImage");
    mainImageURL[i] = webImage.getString("url");
    mainImageWidth[i] = webImage.getInt("width");
    mainImageHeight[i] = webImage.getInt("height");

}
}
