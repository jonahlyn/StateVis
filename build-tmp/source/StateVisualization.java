import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import geomerative.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class StateVisualization extends PApplet {

//import processing.xml.*;


RShape us;
Table data;
int rowCount;
float dataMin = MAX_FLOAT;
float dataMax = MIN_FLOAT;
//Scale scale;
PFont f;

float overlayX;
float overlayY;
String overlayCode;
float overlayValue;

public void setup() {
	f = createFont("Arial", 10, true);
	textFont(f);

	// Get the data
	data = new Table("nestegg-index");
	rowCount = data.getRowCount();

	// Find the minimum and maximum data values
	for (int row = 0; row < rowCount; row++) {
		float value = data.getFloat(row, 2);
		if (value > dataMax) {
			dataMax = value;
		}
		if (value < dataMin) {
			dataMin = value;
		}
	}

	// // Create a scale object
	// scale = new Scale(dataMin, dataMax);

	// Create a Geomerative shape
	RG.init(this);
	us = RG.loadShape("Blank_US_Map.svg");

	// Set the size of the window
	size(PApplet.parseInt(us.width), PApplet.parseInt(us.height));

}


public void draw() {

	background(0xffffffff);

	// Don't display an overlay by default
	overlayValue = 0;



	// strokeWeight(1);
	// stroke(#D9D9D9); //stroke(#2CA25F);

	// // Draw a rectange around the graphic
	// fill(#f2f2f2);
	// rectMode(CENTER);
	// rect(width/2, test.height/2 + 10, test.width, test.height);

	// // Heading
	// smooth();
	// fill(0);
	// textSize(35);
	// textAlign(CENTER);
	// text("U.S. Savings by State", width/2, 50);

	// Get the location of the mouse
	RPoint p = new RPoint(mouseX, mouseY);

	// Iterate through the states shapes
	RShape states = us.children[0];
	for(int i=0;i<states.countChildren();i++) {
		RShape state = states.children[i];
		String code = state.name;
		float value;

		try{
			value = data.getFloat(code, 2);
		} catch (Exception e) {
			value = 0;
		}
		
		RG.ignoreStyles(true);
		float amt = norm(value, dataMin, dataMax);
		int c = lerpColor(0xffE5F5F9, 0xff2CA25F, amt);
		fill(c);
		strokeWeight(1);
		stroke(0xffEFEFEF);

		// Draw the state shape
		state.draw();

		// If the mouse is over the state
		if(states.children[i].contains(p)) {
			RPoint center = state.getCenter();

			// Draw the state shape in mouseover state
			RG.ignoreStyles(true);
			pushMatrix();
			stroke(10,10,10,150);
			strokeWeight(1);
			state.draw();
			popMatrix();

			// Figure out values for the overlay
			overlayX = center.x;
			overlayY = center.y;
			overlayCode = code;
			overlayValue = value;
		}
	}

	// Draw the text overlay if there's a value to display
	if(overlayValue > 0) {
		strokeWeight(1);
		fill(10,10,10,150);
		rectMode(CENTER);
		rect(overlayX, overlayY, 75, 30);
		fill(255);
		textSize(10);
		textAlign(CENTER);
		text(overlayCode + " " + overlayValue, overlayX, overlayY+5);
	}


	// Draw the scale
	// int x = int(test.width) - 175;
	// int y = int(test.height) - 25;
	// scale.draw(x, y);
}


// class Scale {
// 	float min, max;
// 	int x, y;

// 	Scale(float dataMin, float dataMax){
// 		min = dataMin;
// 		max = dataMax;
// 	}

// 	void draw(int startx, int starty){
// 		x = startx;
// 		y = starty;

// 		// Draw text markings
// 		drawText(""+dataMin, x+10, y-25);

// 		// Draw the scale image
// 		for(float i = dataMin; i <= dataMax; i += 1.0) {
// 			color c = lerpColor(#E5F5F9, #2CA25F, norm(i, dataMin, dataMax));
// 			fill(c);
// 			stroke(c);
// 			rect(x, y, 5, 25);
// 			x += 5;
// 		}

// 		// Draw text markings
// 		drawText(""+dataMax, x, y-25);

// 	}

// 	void drawText(String text, int x, int y){
// 		pushMatrix();
// 		translate(x, y);
// 		rotate(radians(-45));
// 		fill(0);
// 		textFont(f);
// 		textSize(10);
// 		text(text, 0, 0);
// 		popMatrix();
// 	}

// }
class Table {
  int rowCount;
  String[][] data;
  
  
  Table(String filename) {
    String[] rows = loadStrings(filename);
    data = new String[rows.length][];
    
    for (int i = 0; i < rows.length; i++) {
      if (trim(rows[i]).length() == 0) {
        continue; // skip empty rows
      }
      if (rows[i].startsWith("#")) {
        continue;  // skip comment lines
      }
      
      // split the row on the tabs
      String[] pieces = split(rows[i], TAB);
      // copy to the table array
      data[rowCount] = pieces;
      rowCount++;
      
      // this could be done in one fell swoop via:
      //data[rowCount++] = split(rows[i], TAB);
    }
    // resize the 'data' array as necessary
    data = (String[][]) subset(data, 0, rowCount);
  }
  
  
  public int getRowCount() {
    return rowCount;
  }
  
  
  // find a row by its name, returns -1 if no row found
  public int getRowIndex(String name) {
    for (int i = 0; i < rowCount; i++) {
      if (data[i][0].equals(name)) {
        return i;
      }
    }
    println("No row named '" + name + "' was found");
    return -1;
  }
  
  
  public String getRowName(int row) {
    return getString(row, 0);
  }


  public String getString(int rowIndex, int column) {
    return data[rowIndex][column];
  }

  
  public String getString(String rowName, int column) {
    return getString(getRowIndex(rowName), column);
  }

  
  public int getInt(String rowName, int column) {
    return parseInt(getString(rowName, column));
  }

  
  public int getInt(int rowIndex, int column) {
    return parseInt(getString(rowIndex, column));
  }

  
  public float getFloat(String rowName, int column) {
    return parseFloat(getString(rowName, column));
  }

  
  public float getFloat(int rowIndex, int column) {
    return parseFloat(getString(rowIndex, column));
  }  
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "StateVisualization" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
