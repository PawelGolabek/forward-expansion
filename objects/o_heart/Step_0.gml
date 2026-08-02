x = owner.x + i * 48
y = owner.y - 128
depth = owner.depth - 3000


if (beating) {
    image_alpha = (sin(current_time / 200) + 1) / 2;
} else {
    image_alpha = 1;
}