/// @description Create Event — o_terrain_generator
randomise();

// ---------------------------------------------------------------
// CONFIG
// ---------------------------------------------------------------
rows            = 12;            // number of triangle levels
flat_object     = o_flat_surface;
cliff_object    = o_cliff;

tile_width      = sprite_get_width(object_get_sprite(flat_object));  
tile_height     = sprite_get_height(object_get_sprite(flat_object)); 

height_min      = 1;      
height_max      = 5;      
max_rise        = 1;      

depth_base      = 0;      
depth_row_step  = 10;     
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

// Store connections for EVERY tile:
// conn_r[r][c] = row of target tile
// conn_c[r][c] = col of target tile
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
// STEP 2 — Assign Height Levels (1-5)
// ---------------------------------------------------------------
levels[0][0] = irandom_range(height_min, height_max);

for (var r = 1; r < rows; r++) {
    for (var c = 0; c <= r; c++) {
        var tr = conn_r[r][c];
        var tc = conn_c[r][c];
        
        var ref_height = (tr != -1 && tc != -1) ? levels[tr][tc] : height_min;

        if (c == path_col[r]) {
            // Trunk stays strictly within +/- 1 step
            levels[r][c] = clamp(ref_height + irandom_range(-1, 1), height_min, height_max);
        } else {
            // Side/Edge tiles respect max_rise from their connected neighbor
            levels[r][c] = irandom_range(height_min, min(height_max, ref_height + max_rise));
        }
    }
}

// ---------------------------------------------------------------
// STEP 3 — Spawn Tiles + Cliffs
// ---------------------------------------------------------------
var f = instance_create_layer(x, y, layer, flat_object);
var bottom_y = start_y + (rows - 1) * tile_height + (tile_height / 2) - f.sprite_height / 4;
instance_destroy(f);

for (var r = 0; r < rows; r++) {
    var row_left_x = start_x - (r * tile_width) / 2;
    var row_y      = start_y + r * tile_height;

    var flat_depth  = depth_base - r * depth_row_step;
    var cliff_depth = depth_base + depth_cliff_gap - r * depth_row_step;

    for (var c = 0; c <= r; c++) {
        var tile_x = row_left_x + c * tile_width;

        // Flat Surface
        f = instance_create_layer(tile_x, row_y, layer, flat_object);
        f.depth = flat_depth;
        f.level = levels[r][c];
        f.row   = r;
        f.col   = c;
        f.image_yscale = 0.6;
        flat_inst[r][c] = f;

        if (c == path_col[r]) {
            path_inst[r] = f;
        }

        // Cliff Underneath
        if (r != rows - 1) {
            var cliff_top_y = row_y + f.sprite_height / 2;
            var cliff_span  = bottom_y - cliff_top_y;

            var cl = instance_create_layer(tile_x, cliff_top_y, layer, cliff_object);
            cl.depth        = cliff_depth;
            cl.image_yscale = cliff_span / sprite_get_height(cl.sprite_index);
            cl.image_xscale = tile_width / sprite_get_width(cl.sprite_index);
            cl.level        = levels[r][c];
            cl.row          = r;
            cl.col          = c;
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

            // Center path segments visually based on connection type
            var is_horizontal = (tr == r);
            var mid_x = (a.x + b.x) / 2;
            var mid_y = (a.y + b.y) / 2 //+ (is_horizontal ? 0 : b.sprite_height / 2);

            var seg = instance_create_layer(mid_x, mid_y, layer, o_path);
            seg.depth = min(a.depth, b.depth) - 1;
            seg.image_angle = point_direction(a.x, a.y, b.x, b.y);

            // Flip sprites horizontally if target is to the right
            if (a.x > b.x) {
                seg.image_xscale = -1;
				seg.y += b.sprite_height / 2
            } else {
                seg.image_xscale = 1;
				seg.y += b.sprite_height / 2
            }

            array_push(path_seg_inst, seg);
        }
    }
}