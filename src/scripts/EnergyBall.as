const KIND_ORIGINAL = 0;
const KIND_ENERGY = 1;
const KIND_1UP = 2;
const SPEED = 2;

var kind = KIND_ORIGINAL;

function scripts(){
	whenFlagClicked(function(){
		hide();
	});
	
	whenIReceive(MSG_ENERGY_APPEAR, function(){
		if (kind == KIND_ORIGINAL) {
			createClone();
		}
	});
	
	whenIStartAsAClone(function(){
		show();
		repeatUntil(ypos <= -180){
			ypos -= SPEED;
		}
		deleteThisClone();
	});
	
	whenIStartAsAClone(function(){
		forever(){
			repeat(5){
				changeEffectBy(EFFECT_BRIGHTNESS, 10);
			}
			repeat(5){
				changeEffectBy(EFFECT_BRIGHTNESS, -10);
			}
		}
	});
	
	whenIStartAsAClone(function(){
		waitUntil(touching("Ship"));
		playSound("energy");
		if (kind == KIND_ENERGY) {
			if (shotLevel == 1) shotLevel = 2;
		} else {
			shipCount++;
		}
		deleteThisClone();
	});
	
	whenIReceive(MSG_GAMEOVER, function(){
		stop(STOPTARGET_OTHER_SCRIPTS);
		deleteThisClone();
	});
	
	whenIReceive(MSG_CLEAR, function(){
		stop(STOPTARGET_OTHER_SCRIPTS);
		deleteThisClone();
	});
}

[ProcDef(fastmode="true")]
function createClone(){
	gotoXY(pickRandomTo(-200, 200), 180);
	if (pickRandomTo(1, 4) != 1){
		switchCostumeTo("energy-ball");
		kind = KIND_ENERGY;
	} else {
		switchCostumeTo("one-up");
		kind = KIND_1UP;
	}
	if (!(kind == KIND_ENERGY && shotLevel > 1)) {
		createCloneOf(CLONETARGET_MYSELF);
	}
	kind = KIND_ORIGINAL;
}