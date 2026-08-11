randomise();

// ---------------------------------------------------------------
// CONFIG
// ---------------------------------------------------------------
rows            = 5;            // number of triangle levels
flat_object     = o_flat_surface;
flat_object_top = o_flat_surface_top;
flat_object_bot = o_flat_surface_bot;
cliff_object    = o_cliff;

path_object_top = o_path_top;

scale = 5;

tile_width      = sprite_get_width(object_get_sprite(flat_object)) * scale;  
tile_height     = sprite_get_height(object_get_sprite(flat_object)) * scale; 

height_min      = 1;      
height_max      = 5;      
max_rise        = 1;      

depth_base      = 0;      
depth_row_step  = 10 * scale;     
depth_cliff_gap = 1000;   

start_x = x; 
start_y = y; 

if (depth_cliff_gap <= (rows - 1) * depth_row_step) {
    show_debug_message("o_terrain_generator: depth_cliff_gap is too small — cliffs may overshadow flats. Increase it.");
}

// ---------------------------------------------------------------
// DATA
// ---------------------------------------------------------------
levels     = array_create(rows); 
flat_inst  = array_create(rows); 
cliff_inst = array_create(rows); 
path_col   = array_create(rows); 
path_inst  = array_create(rows, noone); 

for (var r = 0; r < rows; r++) {
    levels[r]     = array_create(r + 1, 0);
    flat_inst[r]  = array_create(r + 1, noone);
    cliff_inst[r] = array_create(r + 1, noone);
}

// ---------------------------------------------------------------
// STEP 1 — Pick Main Trunk Path (Center) & Balanced Connections
// ---------------------------------------------------------------
path_col[0] = 0;

for (var r = 1; r < rows; r++) {
    var mid_col = round(r / 2);
    var prev_c  = path_col[r - 1];
    
    var choice_left  = prev_c;
    var choice_right = prev_c + 1;
    
    if (abs(choice_left - mid_col) < abs(choice_right - mid_col)) {
        path_col[r] = choice_left;
    } else if (abs(choice_right - mid_col) < abs(choice_left - mid_col)) {
        path_col[r] = choice_right;
    } else {
        path_col[r] = prev_c + irandom(1);
    }
}

conn_r = array_create(rows);
conn_c = array_create(rows);

for (var r = 0; r < rows; r++) {
    conn_r[r] = array_create(r + 1, -1);
    conn_c[r] = array_create(r + 1, -1);
}

for (var r = 1; r < rows; r++) {
    for (var c = 0; c <= r; c++) {
        if (c == path_col[r]) {
            // Main trunk always connects directly up to its parent tile on the trunk
            conn_r[r][c] = r - 1;
            conn_c[r][c] = path_col[r - 1];
        } else {
            // Find ALL valid adjacent connection options for this tile
            var valid_options = []; // Array of structs: { row, col }

            // 1. Up-Left (r-1, c-1)
            if (c - 1 >= 0) {
                array_push(valid_options, { row: r - 1, col: c - 1 });
            }
            // 2. Up-Right (r-1, c)
            if (c <= r - 1) {
                array_push(valid_options, { row: r - 1, col: c });
            }
            // 3. Horizontal Left (r, c-1)
            if (c - 1 >= 0) {
                array_push(valid_options, { row: r, col: c - 1 });
            }
            // 4. Horizontal Right (r, c+1)
            if (c + 1 <= r) {
                array_push(valid_options, { row: r, col: c + 1 });
            }

            // Pick randomly from all valid surrounding neighbors for equal distribution
            if (array_length(valid_options) > 0) {
                var choice = valid_options[irandom(array_length(valid_options) - 1)];
                conn_r[r][c] = choice.row;
                conn_c[r][c] = choice.col;
            }
        }
    }
}

// ---------------------------------------------------------------
// STEP 3 — Spawn Tiles + Cliffs
// ---------------------------------------------------------------
var f = instance_create_depth(x, y, -y - 5000, flat_object);
f.image_xscale = scale
f.image_yscale = scale
var bottom_y = start_y + (rows) * tile_height + (tile_height / 2) - f.sprite_height / 4;
instance_destroy(f);

for (var r = 0; r < rows; r++) {
    var row_left_x = start_x - (r * tile_width) / 2;
    var row_y      = start_y + r * tile_height;

    var flat_depth  = depth_base - r * depth_row_step;
    var cliff_depth = y + 5000 + depth_cliff_gap - r * depth_row_step;

    for (var c = 0; c <= r; c++) {
        var tile_x = row_left_x + c * tile_width;

        // Flat Surface
    //    f = instance_create_depth(tile_x, row_y, y + 5000, flat_object);
        f1 = instance_create_depth(tile_x, row_y, y + 5000, flat_object_top);
        f2 = instance_create_depth(tile_x, row_y, y + 5100, flat_object_bot);
		f = f1;
     //   f.depth = flat_depth;
        f.level = levels[r][c];
        f.row   = r;
        f.col   = c;
        f1.image_yscale = 0.6 * scale;
        f1.image_xscale = scale;	
        f2.image_yscale = 0.6 * scale;
        f2.image_xscale = scale;		
        flat_inst[r][c] = f1;
		
		if(r < 4){
			instance_create_depth(tile_x, row_y + 120, y + 5000, o_enemy_archer)
		}
		if(r < 3){
		}
		if(r < 3){
			instance_create_depth(tile_x + 10, row_y + 60, y + 5000, o_enemy_harpoon)
		}
		if(r < 2){
			instance_create_depth(tile_x - 20, row_y - 20, y + 5000, o_enemy_inferna)
		}
		if(r < 2){
			instance_create_depth(tile_x, row_y + 80, y + 5000, o_enemy_archer)
		}
		if(r < 2){
		}

        if (c == path_col[r]) {
            path_inst[r] = f;
        }

        // Cliff Underneath
			if (r != rows) {
			    var cliff_top_y = row_y + f.sprite_height / 2;
			    var is_last_row = (r == rows - 1);
			    // last row reaches the true bottom; every other row stops at the next row's tile top
			    var cliff_bottom = is_last_row ? bottom_y : (row_y + tile_height + f.sprite_height / 2);
			    var cliff_span   = cliff_bottom - cliff_top_y;

			    var cl = instance_create_depth(tile_x, cliff_top_y, y + 5000, cliff_object);
			    cl.depth = cliff_depth;
			    cl.image_yscale = cliff_span / sprite_get_height(cl.sprite_index);
			    cl.image_xscale = tile_width / sprite_get_width(cl.sprite_index);
			    cl.image_index  = irandom(cl.image_number - 1);
			    cl.level = levels[r][c];
			    cl.row   = r;
			    cl.col   = c;
			    cliff_inst[r][c] = cl;
			}
    }
}

// ---------------------------------------------------------------
// STEP 4 — Spawn Paths (Equal Distribution Across All Tiles)
// ---------------------------------------------------------------
path_seg_inst = [];

for (var r = 1; r < rows; r++) {
    for (var c = 0; c <= r; c++) {
        var tr = conn_r[r][c];
        var tc = conn_c[r][c];

        if (tr != -1 && tc != -1) {
            var a = flat_inst[tr][tc]; // target neighbor tile
            var b = flat_inst[r][c];   // current tile

            // 1. Calculate exact center points of both tiles
            var ax = a.x;
            var ay = a.y;
            var bx = b.x;
            var by = b.y;

            // 2. Find midpoint and distance
            var mid_x = (ax + bx) / 2;
            var mid_y = (ay + by) / 2;
            var dist  = point_distance(ax, ay, bx, by);
            var angle = point_direction(bx, by, ax, ay);

            // 3. Create path instance at the exact midpoint
            var seg = instance_create_depth(mid_x, mid_y, y + 5000, o_path);
            var seg2 = instance_create_depth(mid_x, mid_y, y + 5050, o_path_top);
			
			seg.y += f.sprite_height/2
			seg2.y += f.sprite_height/2
            
            // 4. Scale length (xscale) to match distance, and thickness (yscale) to desired width
            var path_base_width  = sprite_get_width(seg.sprite_index);  // 32px
            var path_base_height = sprite_get_height(seg.sprite_index); // 32px
            
            var path_thickness = 4 * scale; // Adjust '4' to make paths thicker or thinner

            seg.image_xscale = dist / path_base_width;
            seg.image_yscale = path_thickness / path_base_height * scale * 1.8;
            seg2.image_xscale = dist / path_base_width;
            seg2.image_yscale = path_thickness / path_base_height * scale * 1.8;

            // 5. Rotate toward target tile
            seg.image_angle = angle;
            seg2.image_angle = angle;

            // 6. Set depth slightly above the highest tile
       //     seg.depth = min(a.depth, b.depth) - 10;

            array_push(path_seg_inst, seg);
        }
    }
}