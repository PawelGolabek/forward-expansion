function handleHeartsCreation(unit){
	unit.hearts = []
	for(i=0;i<unit.hp*unit.maxhp;i+=1){
		heart = instance_create_depth(x + i * 48,y-128,depth - 3000,o_heart);
		heart.owner = unit;
		heart.i = i;
		array_push(unit.hearts,heart);
	}
}