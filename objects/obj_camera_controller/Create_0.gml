cam = view_camera[0];

cam_x = camera_get_view_x(cam);
cam_y = camera_get_view_y(cam);

dragging = false;

zoom = 0.5;
zoom_min = 0.25;
zoom_max = 0.5;
zoom_speed = 0.1;

prev_mouse_x = mouse_x;
prev_mouse_y = mouse_y;