currentLog = "";
logs = 0;
yDrag = 0;

function log(message1){
	currentLog += "\n" + string(message1);
	logs += 1;
	if(logs > 10){
		yDrag += 25;
	}
}