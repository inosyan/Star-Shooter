const SPEED = 12;
const SPEED2 = 24;
const SHIP_FRONT = 40;

var insNum;
var startY;
var frameCnt;
var n;

function scripts(){
	whenIReceive(MSG_TITLE, function(){
		hide();
	});
	
	whenIReceive(MSG_START, function(){
		repeatUntil(shipCount == 0){
			if (keyPressed(KEY_SPACE) && isGhost == 0) {
				createClones();
				if (shotLevel == 1) wait(0.3);
				if (shotLevel == 2) wait(1);			
			}
		}	
	});
	
	whenIStartAsAClone(function(){
		show();
		frameCnt = 0;
		repeatUntil(ypos > 180){
			if (shotLevel == 1) {
				ypos = startY + frameCnt * SPEED;
			}
			if (shotLevel == 2) {
				n = frameCnt - insNum;
				if (n < 0) n = 0;
				ypos = getAttribute(ATTRIBUTE_YPOS, "Ship") + SHIP_FRONT + n * SPEED2;
				xpos = getAttribute(ATTRIBUTE_XPOS, "Ship")
			}
			frameCnt++;
		}
		deleteThisClone();
	});
	
	whenIStartAsAClone(function(){
		if (shotLevel == 1){
			waitUntil(touching("Enemy") && !touchingColor(0xf56500));
			wait(0);
			deleteThisClone();
		}
	});	
}

[ProcDef(fastmode="true")]
function createClones(){
	goto("Ship");
	startY = ypos + SHIP_FRONT;
	if (shotLevel == 1) {
		createCloneOf(CLONETARGET_MYSELF);
		playSound("laser2");
	}
	if (shotLevel == 2) {
		insNum = 0;
		repeat(10){
			createCloneOf(CLONETARGET_MYSELF);
			insNum++;
		}
		playSound("laser3");
	}	
	
}