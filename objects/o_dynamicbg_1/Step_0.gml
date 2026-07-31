x = o_camera_controller.cam_x
y = o_camera_controller.cam_y - y/30


depth  = 59999996 + y
image_xscale = 1 + 8 * 1/o_camera_controller.zoom
image_yscale = 1 + 8 * 1/o_camera_controller.zoom 