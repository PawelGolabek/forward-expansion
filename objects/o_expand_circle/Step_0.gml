timer++;

var t = clamp(timer / life, 0, 1);
var e = sin(t * pi * 0.5);

var scale = lerp(start_scale, end_scale, e);

image_xscale = scale;
image_yscale = scale;

image_alpha = 1 - e;

x = start_x - (scale - start_scale) * sprite_width * 0.125;
y = start_y - (scale - start_scale) * sprite_height * 0.125;

if (t >= 1)
    instance_destroy();