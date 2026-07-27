/// @description Create Event — o_terrain_generator
/// Builds a 4-level triangle (apex at top) out of o_flat_surface, with an
/// o_cliff underneath each flat spanning from its mid-point down to the
/// bottom of the whole triangle. Heights (1-5) are randomised but a
/// guaranteed climbable path (max ±1 per step) always exists from the
/// apex to the base.
///
/// USAGE: create a new object called o_terrain_generator (no sprite
/// needed), paste this into its Create Event, then place one instance
/// in the room wherever you want the apex to sit.

// ---------------------------------------------------------------
// CONFIG — tweak these (either here, or copy the whole Create event
// into a User Event and set overrides in the room's creation code
// before calling it, if you want per-instance settings)
// ---------------------------------------------------------------
rows            = 4;     // number of triangle levels (row 0 = apex/1 tile, +1 tile per row after)
flat_object     = o_flat_surface;
cliff_object    = o_cliff;

tile_width      = sprite_get_width(object_get_sprite(flat_object));   // horizontal spacing between tiles
tile_height     = sprite_get_height(object_get_sprite(flat_object));  // vertical spacing between rows

height_min      = 1;      // lowest allowed terrain level
height_max      = 5;      // highest allowed terrain level
max_rise        = 1;      // a tile can be at most this much HIGHER than the level it "should" be
                          // at (based on the tile(s) above it) — it can be any amount LOWER, that's fine

depth_base      = 0;      // depth of the topmost (apex) flat tile — shift everything back/forward with this
depth_row_step  = 10;     // how much closer to the camera (lower depth) each row down gets
depth_cliff_gap = 1000;   // extra depth added to ALL cliffs so they always stay behind ALL flats
                          // must be > (rows-1) * depth_row_step — checked below

start_x = x; // world x of the apex (top) tile's centre
start_y = y; // world y of the apex (top) tile's centre

if (depth_cliff_gap <= (rows - 1) * depth_row_step) {
    show_debug_message("o_terrain_generator: depth_cliff_gap is too small — cliffs may overshadow flats. Increase it.");
}

// ---------------------------------------------------------------
// DATA — kept on the instance in case other objects need to read it later
// ---------------------------------------------------------------
levels     = array_create(rows); // levels[row][col]     -> terrain height (1-5)
flat_inst  = array_create(rows); // flat_inst[row][col]  -> instance id of that tile's o_flat_surface
cliff_inst = array_create(rows); // cliff_inst[row][col] -> instance id of that tile's o_cliff
path_col   = array_create(rows); // column used at each row for the guaranteed climb path
path_inst  = array_create(rows, noone); // path_inst[row] -> instance id of that row's climbable o_flat_surface

path_line_color = c_yellow; // colour used to draw the climb path in the Draw event
path_line_width = 3;        // line width (pixels) used to draw the climb path

for (var r = 0; r < rows; r++) {
    levels[r]     = array_create(r + 1, 0);
    flat_inst[r]  = array_create(r + 1, noone);
    cliff_inst[r] = array_create(r + 1, noone);
}

// ---------------------------------------------------------------
// STEP 1 — pick a guaranteed path from apex to base where every step
// differs by at most 1 in height level. Tile (r-1, k) always has
// exactly two children: (r, k) and (r, k+1) — so "left" (+0) or
// "right" (+1) is always a valid move.
// ---------------------------------------------------------------
path_col[0] = 0;
for (var r = 1; r < rows; r++) {
    path_col[r] = path_col[r - 1] + irandom(1); // 0 = stay/left, 1 = right
}

// ---------------------------------------------------------------
// STEP 2 — assign a height level (1-5) to every tile
// ---------------------------------------------------------------
levels[0][0] = irandom_range(height_min, height_max); // apex is fully free

for (var r = 1; r < rows; r++) {
    for (var c = 0; c <= r; c++) {

        if (c == path_col[r]) {
            // On the guaranteed climb path — stay within 1 level of the tile above it
            var prev_h = levels[r - 1][path_col[r - 1]];
            levels[r][c] = clamp(prev_h + irandom_range(-1, 1), height_min, height_max);
        } else {
            // Work out what this tile is "expected" to be, based on its parent(s) above it
            var has_left  = (c >= 1);       // parent at (r-1, c-1)
            var has_right = (c <= r - 1);   // parent at (r-1, c)
            var target;
            if (has_left && has_right) {
                target = max(levels[r - 1][c - 1], levels[r - 1][c]);
            } else if (has_left) {
                target = levels[r - 1][c - 1];
            } else {
                target = levels[r - 1][c];
            }
            // never more than max_rise ABOVE target — free to be any amount lower
            levels[r][c] = irandom_range(height_min, min(height_max, target + max_rise));
        }
    }
}

// ---------------------------------------------------------------
// STEP 3 — spawn the tiles + cliffs
// ---------------------------------------------------------------
var f = instance_create_layer(x, y, layer, flat_object);
var bottom_y = start_y + (rows - 1) * tile_height + (tile_height / 2) - f.sprite_height/4// bottom edge of the whole triangle
instance_destroy(f)

for (var r = 0; r < rows; r++) {

    var row_left_x = start_x - (r * tile_width) / 2; // centre x of the leftmost tile in this row
    var row_y       = start_y + r * tile_height;       // centre y of every tile in this row

    var flat_depth  = depth_base - r * depth_row_step;
    var cliff_depth = depth_base + depth_cliff_gap - r * depth_row_step;

    for (var c = 0; c <= r; c++) {

        var tile_x = row_left_x + c * tile_width;

        // --- flat surface ---
        f = instance_create_layer(tile_x, row_y, layer, flat_object);
        f.depth = flat_depth;
        f.level = levels[r][c]; // expose the chosen height level to the tile itself
        f.row   = r;
        f.col   = c;
		f.image_yscale = 0.6
        flat_inst[r][c] = f;

        if (c == path_col[r]) {
            path_inst[r] = f; // this tile is part of the guaranteed climb path
        }

        // --- cliff underneath: from the middle of this flat down to the bottom of the triangle ---
		if( r != rows -1){
	        var cliff_top_y = row_y + f.sprite_height/2;
	        var cliff_span  = bottom_y - cliff_top_y;

	        var cl = instance_create_layer(tile_x, cliff_top_y, layer, cliff_object);
	        cl.depth        = cliff_depth;
	        cl.image_yscale = cliff_span / sprite_get_height(cl.sprite_index);
	        cl.image_xscale = tile_width / sprite_get_width(cl.sprite_index);
	        cl.level = levels[r][c];
	        cl.row   = r;
	        cl.col   = c;
	        cliff_inst[r][c] = cl;
	    }
	}
}


// ---------------------------------------------------------------
// STEP 4 — spawn o_path objects linking consecutive tiles along the
// guaranteed climb path (visually shows the route from apex to base)
// ---------------------------------------------------------------
path_seg_inst = array_create(rows - 1, noone); // path_seg_inst[r] = segment connecting row r to row r+1

examplepath = instance_create_layer(x,y, layer, o_path);
for (var r = 1; r < rows; r++) {
    var a = path_inst[r - 1]; // upper tile
    var b = path_inst[r];     // lower tile

    var mid_x = (a.x + b.x) / 2;
    var mid_y = (a.y + b.y) / 2 + f.sprite_height/2;

    var p = instance_create_layer(mid_x, mid_y, layer, o_path);
    p.depth = min(a.depth, b.depth) - 1; // sit in front of both flats it connects
    p.image_angle = point_direction(a.x, a.y, b.x, b.y);
	

    // path_col[r] == path_col[r-1]     -> moved LEFT going down  -> xscale 1 (default)
    // path_col[r] == path_col[r-1] + 1 -> moved RIGHT going down -> xscale -1 (flip)
    var went_right = (path_col[r] == path_col[r - 1] + 1);
    p.image_xscale = went_right ? -1 : 1;
	if (went_right) {
	    p.image_xscale = -1;
	    p.x += lengthdir_x(sprite_width, p.image_angle);
	    p.y += lengthdir_y(sprite_width, p.image_angle);
	} else {
	    p.image_xscale = 1;
	}

    path_seg_inst[r - 1] = p;
}

instance_destroy(examplepath)