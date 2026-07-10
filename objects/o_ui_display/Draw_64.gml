draw_text(0,0,global.crystals)
if(global.draggingUnit == noone){
	draw_text(0,50,"noone")
}

if(global.deployHighlight != noone){
	draw_text(0,90,global.deployHighlight)
}

draw_text(0,180,o_clock.blocked)
	
	
draw_text(0,360,string(fps_real))