XML xml;
PShape ps;
PShape test;
Table data;
int rowCount;
float dataMin = MAX_FLOAT;
float dataMax = MIN_FLOAT;

void setup() {
	size(640, 480);

	// Get the data
	data = new Table("nestegg-index");
	rowCount = data.getRowCount();

	// Get the map
	// xml = loadXML("Blank_US_Map.svg");
	// bindSVG(xml);
	// ps = new PShapeSVG(xml);

	test = loadShape("Blank_US_Map.svg");
	size(int(test.width), int(test.height));

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


void draw() {

	background(#ffffff);

	strokeWeight(1);
	stroke(#D9D9D9); //stroke(#2CA25F);

	fill(#f2f2f2);
	rect(10, 10, width-20, height-20);

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

			shape(state, (width*.125), 75, width - (width*.25), height - (height*.25));
			//shape(state, 0, 0);
		}
	}


	int x = width - 200;
	int y = height - 50;
	for(float i = dataMin; i <= dataMax; i += 1.0) {
		color c = lerpColor(#E5F5F9, #2CA25F, norm(i, dataMin, dataMax));
		fill(c);
		noStroke();
		rect(x, y, 5, 25);
		x += 5;
	}

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
