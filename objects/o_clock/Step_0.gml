 
 // Only tick if there is actually something waiting in line
if (!ds_queue_empty(action_queue)) {
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
    // Keep the timer refreshed when the queue is completely empty
    action_timer = 0; 
}