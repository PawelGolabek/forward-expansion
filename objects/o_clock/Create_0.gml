toNextEvent = 0;
maxToNextEvent = 1000000;

debug = false;
blocked = false;
ui_to_block = [o_spawner_parent]


// Create the FIFO queue
action_queue = ds_queue_create();
