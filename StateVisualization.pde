XML xml;
PShape ps;
PShape test;
Table data;
int rowCount;
float dataMin = MAX_FLOAT;
float dataMax = MIN_FLOAT;
Scale scale;
PFont f;

void setup() {
	f = createFont("Arial", 10, true);

	// Get the data
	data = new Table("nestegg-index");
	rowCount = data.getRowCount();

	// Get the map
	// xml = loadXML("Blank_US_Map.svg");
	// bindSVG(xml);
	// ps = new PShapeSVG(xml);

	test = loadShape("Blank_US_Map.svg");
	size(int(test.width) + 20, int(test.height) + 20);
	println("Width: " + test.width + " Height: " + test.height);

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

	scale = new Scale(dataMin, dataMax);

}


void draw() {

	background(#ffffff);

	strokeWeight(1);
	stroke(#D9D9D9); //stroke(#2CA25F);

	fill(#f2f2f2);
	rectMode(CENTER);
	rect(width/2, test.height/2 + 10, test.width, test.height);

	smooth();
	fill(0);
	textSize(35);
	textAlign(CENTER);
	text("U.S. Savings by State", width/2, 50);

	stroke(#BDBDBD); //stroke(#2CA25F);

	for (int row = 0; row < rowCount; row++) {
		String abbrev = data.getRowName(row);
		PShape state = test.getChild(abbrev);


		if (state != null) {
			state.disableStyle();
			float value = data.getFloat(row, 2);
			float amt = norm(value, dataMin, dataMax);
			color c = lerpColor(#E5F5F9, #2CA25F, amt);
			fill(c);

			shape(state, (test.width*.125), 75, test.width - (test.width*.25), test.height - (test.height*.25));
			//shape(state, 0, 0);
		}
	}

	// Draw the scale
	int x = int(test.width) - 175;
	int y = int(test.height) - 25;
	scale.draw(x, y);
}

void bindSVG(XML svg) {
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


class Scale {
	float min, max;
	int x, y;

	Scale(float dataMin, float dataMax){
		min = dataMin;
		max = dataMax;
	}

	void draw(int startx, int starty){
		x = startx;
		y = starty;

		// Draw text markings
		drawText(""+dataMin, x+10, y-25);

		// Draw the scale image
		for(float i = dataMin; i <= dataMax; i += 1.0) {
			color c = lerpColor(#E5F5F9, #2CA25F, norm(i, dataMin, dataMax));
			fill(c);
			stroke(c);
			rect(x, y, 5, 25);
			x += 5;
		}

		// Draw text markings
		drawText(""+dataMax, x, y-25);

	}

	void drawText(String text, int x, int y){
		pushMatrix();
		translate(x, y);
		rotate(radians(-45));
		fill(0);
		textFont(f);
		textSize(10);
		text(text, 0, 0);
		popMatrix();
	}

}