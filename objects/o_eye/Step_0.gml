// Step event
if (blink_state == "blink") {
    blink_time -= delta_time;
    if (blink_time <= 0) {
        blink_time = 0;
        blink_state = "unblink";
    }
}
else if (blink_state == "unblink") {
    blink_time += delta_time;
    if (blink_time >= blink_max_time) {
        blink_time = blink_max_time;
        blink_state = "default";
    }
}
