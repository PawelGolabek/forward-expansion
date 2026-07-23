cam = view_camera[0];

cam_x = x;
cam_y = y;

camera_set_view_pos(cam, cam_x, cam_y);

dragging = false;

zoom = 1;
zoom_min = 0.8;
zoom_max = 5;
zoom_speed = 1;

prev_mouse_x = mouse_x;
prev_mouse_y = mouse_y;