cam = view_camera[0];

cam_x = x
cam_y = y

camera_set_view_pos(cam, cam_x, cam_y);

dragging = false;

zoom = 0.5;
zoom_min = 0.25;
zoom_max = 0.5;
zoom_speed = 0.1;

prev_mouse_x = mouse_x;
prev_mouse_y = mouse_y;