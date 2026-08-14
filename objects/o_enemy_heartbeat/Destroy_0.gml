// Inherit the parent event
event_inherited();

if(instance_exists(myShield)){
	instance_destroy(myShield);
}