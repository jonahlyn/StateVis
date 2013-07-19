import geomerative.*;

RShape us;
Table data;
int rowCount;
float dataMin = MAX_FLOAT;
float dataMax = MIN_FLOAT;
ColorScale cscale;
PFont f;
float overlayX;
float overlayY;
String overlayCode;
float overlayValue;
String description;

void setup() {
	// Setup the font
	f = createFont("Arial", 10, true);
	textFont(f);

	description = "Index ranking the ability to build and nurture financial saving and retirement assets. Factors include: Savings propensity (proportion of households in the area that have a savings product of any type — e.g., regular savings account, CD, IRA); 401(k) retirement plan penetration; Non-401(k) retirement savings plan penetration (e.g., pension plans); Investing propensity (proportion of households in the area that have any investment product or service, excluding 401(k) plans); Net worth; Owner-occupied housing value; First mortgage balance; Personal debt level; Home ownership; Household income, Cost of living; Local employment rate.";

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

	// Create a scale object
	cscale = new ColorScale(dataMin, dataMax);

	// Create a Geomerative shape
	RG.init(this);
	us = RG.loadShape("Blank_US_Map.svg");

	// Set the size of the window
	size(int(us.width*1.2), int(us.height*1.1));
}


void draw() {

	// Clear the screen
	background(#ffffff);

	// Don't display an overlay by default
	overlayValue = 0;

	// Draw a rectange around the graphic
	pushStyle();
	strokeWeight(1);
	stroke(#D9D9D9);
	fill(#f2f2f2);
	rectMode(CENTER);
	rect(width/2, height/2, width-20, height-20);
	popStyle();

	// Draw the Heading
	smooth();
	fill(0);
	textSize(35);
	textAlign(CENTER);
	text("U.S. Savings by State", width/2, 50);

	// Draw the description
	textSize(10);
	textAlign(LEFT);
	text(description, width-width/4, height-260, 250, 250);

	// Draw the Source Text
	fill(#777777);
	textSize(10);
	textAlign(LEFT);
	text("Source: Nest Egg Index by state, A.G. Edwards.", 15, height-15);

	// Draw the scale
	cscale.draw(int(us.width)/2+60, int(us.height)-15);

	pushMatrix();

	// Translate the drawing of the map
	translate(10, 25);

	// Get the location of the mouse
	RPoint p = new RPoint(mouseX, mouseY);
	p.translate(-10, -25);

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

			// Draw the state shape in mouseover state
			RG.ignoreStyles(true);
			stroke(10,10,10,150);
			strokeWeight(1);
			state.draw();

			// Figure out values for the overlay
			overlayX = center.x;
			overlayY = center.y;
			overlayCode = code;
			overlayValue = value;
		}
	}

	// Draw the text overlay if there's a value to display
	if(overlayValue > 0) {
		pushStyle();
		strokeWeight(1);
		fill(10,10,10,150);
		rectMode(CENTER);
		rect(overlayX, overlayY, 75, 30);
		fill(255);
		textSize(10);
		textAlign(CENTER);
		text(overlayCode + " " + overlayValue, overlayX, overlayY+5);
		popStyle();
	}

	popMatrix();
}


class ColorScale {
	float min, max;
	int x, y;

	ColorScale(float dataMin, float dataMax){
		min = dataMin;
		max = dataMax;
	}

	void draw(int startx, int starty){
		x = startx;
		y = starty;

		// Draw text markings
		drawText(""+dataMin, x, y-3, LEFT);

		// Draw the scale image
		for(float i = dataMin; i <= dataMax; i += 1.0) {
			color c = lerpColor(#E5F5F9, #2CA25F, norm(i, dataMin, dataMax));
			fill(c);
			stroke(c);
			rect(x, y, 5, 25);
			x += 5;
		}

		// Draw text markings
		drawText(""+dataMax, x, y-3, RIGHT);

	}

	void drawText(String text, int x, int y, int alignment){
		pushMatrix();
		translate(x, y);
		//rotate(radians(-45));
		fill(0);
		textFont(f);
		textSize(10);
		textAlign(alignment);
		text(text, 0, 0);
		popMatrix();
	}

}