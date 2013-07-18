//import processing.xml.*;
import geomerative.*;

RShape us;
Table data;
int rowCount;
float dataMin = MAX_FLOAT;
float dataMax = MIN_FLOAT;
//Scale scale;
PFont f;

void setup() {
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
	size(int(us.width), int(us.height));

}


void draw() {

	background(#ffffff);

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
		color c = lerpColor(#E5F5F9, #2CA25F, amt);
		fill(c);
		strokeWeight(1);
		stroke(#EFEFEF);

		// Draw the state shape
		state.draw();

		// If the mouse is over the state
		if(states.children[i].contains(p)) {
			RPoint center = state.getCenter();

			RG.ignoreStyles(true);

			pushMatrix();
			stroke(10,10,10,150);
			strokeWeight(1);
			state.draw();
			popMatrix();
			
			//text overlay
			strokeWeight(1);
			fill(10,10,10,150);
			rectMode(CENTER);
			rect(center.x, center.y, 75, 30);
			fill(255);
			textSize(10);
			textAlign(CENTER);
			text(code + " " + value, center.x, center.y+5);
		}
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