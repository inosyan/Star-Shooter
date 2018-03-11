
function scripts(){
	whenFlagClicked(function(){
		hide();
		broadcast(MSG_TITLE);
	});
	
	whenIReceive(MSG_TITLE, function(){
		shipCount = 3;
		score = 0;
		stageNum = 1;
		shotLevel = 1;
		waitUntil(keyPressed(KEY_SPACE));
		waitUntil(!keyPressed(KEY_SPACE));
		broadcast(MSG_START);
		broadcast(MSG_STAGE_CHANGED);		
	});
	
	whenIReceive(MSG_GAMEOVER, function(){
		stop(STOPTARGET_OTHER_SCRIPTS);
		waitForTitle();
	});	
	
	whenIReceive(MSG_CLEAR, function(){
		stop(STOPTARGET_OTHER_SCRIPTS);		
		waitForTitle();
	});
	
	whenIReceive(MSG_START, function(){
		stop(STOPTARGET_OTHER_SCRIPTS);
		forever(){
			wait(pickRandomTo(10, 20));
			broadcast(MSG_ENERGY_APPEAR);
		}
	});
	
	whenIReceive(MSG_GOTO_NEXT_STAGE, function(){
		wait(2);
		if (stageNum == MAX_STAGE) {
			broadcast(MSG_CLEAR);
		} else {
			stageNum++;
			broadcast(MSG_STAGE_CHANGED);
		}
	});
}

function waitForTitle() {
	wait(3);
	waitUntil(keyPressed(KEY_SPACE));
	waitUntil(!keyPressed(KEY_SPACE));
	broadcast(MSG_TITLE);
}
