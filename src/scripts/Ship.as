
const MOVE_VAL = 6;
var crashing;

function scripts(){
	whenIReceive(MSG_TITLE, function(){
		hide();
		switchCostumeTo("ship");
	});
	
	whenIReceive(MSG_START, function(){
		crashing = 0;
		isGhost = 0;		
		
		broadcast(MSG_SHIP_APPEAR);
		repeatUntil(shipCount == 0){
			if (crashing == 0){
				if(keyPressed(KEY_UP_ARROW)) ypos += MOVE_VAL;
				if(keyPressed(KEY_DOWN_ARROW)) ypos -= MOVE_VAL;
				if(keyPressed(KEY_LEFT_ARROW)) xpos -= MOVE_VAL;
				if(keyPressed(KEY_RIGHT_ARROW)) xpos += MOVE_VAL;
			}
		}
	});
	
	whenIReceive(MSG_SHIP_APPEAR, function(){
		gotoXY(0, -180);
		show();
		repeat(24){
			move(2);
		}
	});
	
	whenIReceive(MSG_SHIP_APPEAR, function(){
		if (isGhost == 1){			
			repeat(8){
				setEffectTo(EFFECT_GHOST, 50);
				wait(0.1);
				setEffectTo(EFFECT_GHOST, 10);
				wait(0.1);
			}
			clearGraphicEffects();
			isGhost = 0;
		}
	});
	
	whenIReceive(MSG_START, function(){
		repeatUntil(shipCount == 0){
			waitUntil(isGhost == 0 && touching("Enemy"));
			isGhost = 1;
			playSound("explode2");
			switchCostumeTo("ship-crash");
			crashing = 1;
			repeat(10){
				changeEffectBy(EFFECT_GHOST, 10);
			}
			shipCount--;
			shotLevel = 1;
			if (shipCount == 0){
				hide();
				clearGraphicEffects();
				broadcast(MSG_GAMEOVER);
			} else {
				wait(1);
				clearGraphicEffects();
				switchCostumeTo("ship");
				crashing = 0;
				broadcast(MSG_SHIP_APPEAR);
			}
		}
	});
}

}