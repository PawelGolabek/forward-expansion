x = owner.x + i * 48
y = owner.y - 128
depth = owner.depth - 4000
container.x = x
container.y = y

if (beating) {
    image_alpha = (sin(current_time / 200) + 1) / 2;
} else {
    image_alpha = 1;
}