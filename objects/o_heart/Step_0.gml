var heartsPerRow = 5;
var spacing = sprite_width + 4;

var col = i mod heartsPerRow;
var row = i div heartsPerRow;

x = owner.x + col * spacing;
y = owner.y - 128 + row * spacing;
depth = owner.depth - 4000;

container.x = x;
container.y = y;

if (beating) {
    image_alpha = (sin(current_time / 200) + 1) / 2;
} else {
    image_alpha = 1;
}