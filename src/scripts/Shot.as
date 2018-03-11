
function scripts(){
	whenIReceive(MSG_TITLE, function(){
		hide();
	});
	
	whenIReceive(MSG_START, function(){
		repeatUntil(shipCount == 0){
			if (keyPressed(KEY_SPACE)) {
				createCloneOf(CLONETARGET_MYSELF);
				wait(0.5);
			}
		}	
	});
	
	whenIStartAsAClone(function(){
		goto("Ship");
		move(40);
		show();
		repeatUntil(ypos > 180){
			ypos += 6;
		}
		deleteThisClone();
	});
	
	whenIStartAsAClone(function(){		
		waitUntil(touching("Enemy") && !touchingColor(0xf56500));
		wait(0);
		deleteThisClone();
	});	
}