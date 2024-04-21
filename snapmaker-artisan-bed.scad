
PHYSICAL_BED_WIDTH = 406;
PHYSICAL_BED_DEPTH = 420;
PHYSICAL_BED_CORNER_RADIUS = 7;

LINE_WIDTH = 0.5;
BED_WIDTH = 400;
BED_DEPTH = 400;
BED_CORDER_RADIUS = 5;

WIDTH_SECTIONS = 8;
DEPTH_SECTIONS = 8;

INNER_WIDTH = 264;
INNER_DEPTH = 264;
INNER_CORNER_RADIUS = 10;

HEIGHT = 4;


section_width_step = BED_WIDTH / WIDTH_SECTIONS;
section_depth_step = BED_DEPTH / DEPTH_SECTIONS;

translate([0, 0, -HEIGHT])
difference() {
    linear_extrude(height = HEIGHT) 
        roundedSquare(PHYSICAL_BED_WIDTH, PHYSICAL_BED_DEPTH, PHYSICAL_BED_CORNER_RADIUS);
    translate([0, 0, -1]) linear_extrude(height = HEIGHT+2) bed_lines();
}

module bed_lines() {
    translate([BED_WIDTH/2 - 50, -BED_DEPTH / 2 + 30, 0]) 
        text("snapmaker", size = 10, font = "Arial:style=Bold", halign = "center", valign = "center");

    roundedSquareLine(BED_WIDTH, BED_DEPTH, BED_CORDER_RADIUS, LINE_WIDTH);

    for (i = [section_width_step : section_width_step : BED_WIDTH-1]) {
        translate([i - BED_WIDTH/2, 0, 0])
            square([LINE_WIDTH, BED_DEPTH], center = true);
    }

    for (i = [section_depth_step : section_depth_step : BED_DEPTH-1]) {
        translate([0, i - BED_DEPTH/2, 0])
            square([BED_WIDTH, LINE_WIDTH], center = true);
    }

    roundedSquareLine(INNER_WIDTH, INNER_DEPTH, INNER_CORNER_RADIUS, LINE_WIDTH);
}

module roundedSquare(width, depth, radius) {
    hull() {
        for (x = [-1, 1]){
            for (y = [-1, 1]){
                translate([x * (width/2 - radius), y * (depth/2 - radius), 0])
                    circle(r = radius);
            }
        }
    }
}

module roundedSquareLine(width, depth, radius, line_width) {
    difference() {
        roundedSquare(width + line_width, depth + line_width, radius);
        roundedSquare(width - line_width, depth - line_width, radius);
    }
}