import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class StateVisualization extends PApplet {

XML xml;
PShape ps;
PShape test;
Table data;
int rowCount;
float dataMin = MAX_FLOAT;
float dataMax = MIN_FLOAT;

public void setup() {
	size(640, 480);

	// Get the data
	data = new Table("nestegg-index");
	rowCount = data.getRowCount();

	// Get the map
	// xml = loadXML("Blank_US_Map.svg");
	// bindSVG(xml);
	// ps = new PShapeSVG(xml);

	test = loadShape("Blank_US_Map.svg");
	size(PApplet.parseInt(test.width), PApplet.parseInt(test.height));

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

}


public void draw() {

	background(0xffffffff);

	strokeWeight(1);
	stroke(0xffD9D9D9); //stroke(#2CA25F);

	fill(0xfff2f2f2);
	rect(10, 10, width-20, height-20);

	smooth();
	fill(0);
	textSize(35);
	textAlign(CENTER);
	text("U.S. Savings by State", width/2, 50);

	stroke(0xffBDBDBD); //stroke(#2CA25F);

	for (int row = 0; row < rowCount; row++) {
		String abbrev = data.getRowName(row);
		PShape state = test.getChild(abbrev);


		if (state != null) {
			state.disableStyle();
			float value = data.getFloat(row, 2);
			float amt = norm(value, dataMin, dataMax);
			int c = lerpColor(0xffE5F5F9, 0xff2CA25F, amt);
			fill(c);

			shape(state, (width*.125f), 75, width - (width*.25f), height - (height*.25f));
			//shape(state, 0, 0);
		}
	}


	int x = width - 200;
	int y = height - 50;
	for(float i = dataMin; i <= dataMax; i += 1.0f) {
		int c = lerpColor(0xffE5F5F9, 0xff2CA25F, norm(i, dataMin, dataMax));
		fill(c);
		noStroke();
		rect(x, y, 5, 25);
		x += 5;
	}

}

public void bindSVG(XML svg) {
	XML[] paths = svg.getChild("g").getChildren("path");
	
	for(int i = 0; i < paths.length; i++){
		String code = paths[i].getString("id");
		//Float value = data.getFloat(code, 2);

		if(code.length() > 2){ continue; }

		try {
			println(code + " " + data.getFloat(code, 2));
			paths[i].setString("fill", "#61E2F0");
		} catch (Exception e) {
			println("Caught an error");
		}		
	}
}
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
