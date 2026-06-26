draw_self()
if(target != noone){
	draw_text(x,y+30,target.hp)
}else{
	draw_text(x,y+50,"0")
}

var w = 40;
var h = 6;

var x1 = x - w * 0.5;
var y1 = y - 40;

var hp_ratio = hp / maxhp;

// background
draw_set_color(c_red);
draw_rectangle(x1, y1, x1 + w, y1 + h, false);

// fill
draw_set_color(c_lime);
draw_rectangle(x1, y1, x1 + (w * hp_ratio), y1 + h, false);

draw_set_color(c_white);



// 2. Check if a valid unit is currently being dragged
if (instance_exists(global.draggingUnit))
{
    // 3. Check if the dragged unit is an enemy
    if (global.draggingUnit.allegience != allegience or global.draggingUnit == self)
    {
        // 4. Check if that dragged enemy is within THIS unit's range
        var dist = point_distance(x, y, global.draggingUnit.x, global.draggingUnit.y);
        
        if (dist <= range or global.draggingUnit == self)
        {
            // The enemy is in range! Draw this unit's threat radius.
            var circleColor = c_orange; // Orange/Yellow works great for a warning outline
            
            draw_set_alpha(0.3); // Semi-transparent outline
            draw_circle_color(x, y, range, circleColor, circleColor, true);
            
            draw_set_alpha(0.05); // Super faint filled center
            draw_circle_color(x, y, range, circleColor, circleColor, false);
            
            // Reset alpha back to normal
            draw_set_alpha(1.0);
        }
    }
}