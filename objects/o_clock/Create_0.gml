toNextEvent = 0;
maxToNextEvent = 100000;

multipleDeploymentInProgress = false;

debug = false;
blocked = false;
ui_to_block = [o_spawner_parent]
animationBlocked = false;
global.unitActing = noone;

// Create the FIFO queue
action_queue = ds_queue_create();
