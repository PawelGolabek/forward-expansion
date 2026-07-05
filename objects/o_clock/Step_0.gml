 
 // Only tick if there is actually something waiting in line
if (!ds_queue_empty(action_queue)) {
	blocked = true;
	for (var i = 0; i < array_length(ui_to_block); i++)
		{
		    ui_to_block[i].active = false;
		}
	toNextEvent -= delta_time;
	if(toNextEvent < 0){
		toNextEvent = 0;
	}
    
    if (toNextEvent = 0) {
        // Pull the oldest item out of the FIFO queue
        var _next_action = ds_queue_dequeue(action_queue);
        
        // Execute the assigned function
        _next_action.func();
        // Reset the timer for the next item in line
		toNextEvent = maxToNextEvent;
    }
} else {
	blocked = false;
	// random moment to reset parry but a good one
    action_timer = 0; 
	with(o_unit){
		if(parry){
			parried = false;
		}
	}
}