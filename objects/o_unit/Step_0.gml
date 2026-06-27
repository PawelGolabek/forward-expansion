// =====================================================================
// ADD TO CREATE EVENT (if not already present):
//
//   dragging      = false;
//   mask_index    = standard_collisions;
//   last_valid_x  = x;
//   last_valid_y  = y;
//
// =====================================================================

depth = -y;
tmpTarget = noone;

if (mouse_check_button_pressed(mb_left))
{
    if (position_meeting(mouse_x, mouse_y, id))
    {
        dragging = true;
        last_valid_x = x;
        last_valid_y = y;
    }
}

if (dragging)
{
    mask_index = dragging_mask;
    global.draggingUnit = self;
    x = mouse_x;
    y = mouse_y;

    // --- COLLISION RESOLUTION ---
    // This runs fully every single step, whether the mouse is still held
    // or about to be released this same step. There is no separate pass
    // that only happens on drop, so the position you see WHILE dragging
    // is exactly the position you get if you let go right now.
    var _iterations = 300;
    repeat (_iterations)
    {
        var _list = ds_list_create();
        var _num = instance_place_list(x, y, o_unit, _list, false);
        var _moved = false;

        for (var i = 0; i < _num; i++)
        {
            var _other = _list[| i];
            if (_other == id) continue;

            var _dir = point_direction(_other.x, _other.y, x, y);
            if (x == _other.x && y == _other.y) _dir = random(360);

            x += lengthdir_x(1, _dir);
            y += lengthdir_y(1, _dir);
            _moved = true;
        }

        ds_list_destroy(_list);
        if (!_moved) break; // fully resolved, stop early
    }
    // -----------------------------

    // Track the last confirmed collision-free position. This is an
    // absolute fallback for the rare case 300 iterations isn't enough
    // (e.g. completely boxed in) — guarantees we never show or drop
    // an overlapping position, even then.
    var _check = instance_place(x, y, o_unit);
    if (_check == noone || _check == id)
    {
        last_valid_x = x;
        last_valid_y = y;
    }
    else
    {
        x = last_valid_x;
        y = last_valid_y;
    }

    findNewTargetForSelf();

    if (!mouse_check_button(mb_left))
    {
        // No extra resolution here on purpose — x/y above is already
        // the final, validated position. Dropping just locks it in.
        resetTargets();
        dragging = false;
        global.draggingUnit = noone;
    }
}
else
{
    mask_index = standard_collisions;
}
