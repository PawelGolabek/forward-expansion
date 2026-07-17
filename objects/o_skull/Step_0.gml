


x = unit.xx
y = unit.yy

depth = unit.depth - 50


breathe_timer += breathe_speed * (delta_time / 1000000) * 60;
image_xscale = base_scale + sin(breathe_timer) * breathe_amount;
image_yscale = base_scale; // Finished off your cut-off line here!

